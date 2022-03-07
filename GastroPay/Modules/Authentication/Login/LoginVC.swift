//
//  LoginVC.swift
//  Authentication
//
//  Created by  on 6.12.2019.
//

import UIKit
import Then

import NotificationCenter
import YPNavigationBarTransition
import AloeStackView
import MaterialComponents.MaterialTextFields

public class LoginVC: MIViewController {
    var viewModel: LoginVM!
    let loginButtonLock = NSLock()
        
    public init(viewModel: LoginVM?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let viewModel = viewModel{
            self.viewModel = viewModel
        }
        else{
            self.viewModel = LoginVM(whenLoginButtonClicked:{
                self.onTappedLogin()
            }, whenTextFieldChanged: { textField in
                self.textFieldChanged(textField: textField)
            })
        }
        
        self.viewModel.setupView(vc: self)
        
        navigationController?.navigationBar.backIndicatorImage = self.viewModel.navigationBackIcon
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = self.viewModel.navigationBackIcon
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.titleView = self.viewModel.loginView.navigationTitleLabel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.viewModel.navigationBackIcon, style: .done, target: self, action: #selector(tappedClose))
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        animateWithKeyboard { keyboardHeight in
            self.viewModel.animateWithKeyboard(keyboardHeight: keyboardHeight, view: self.view)
        }
        
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
}

extension LoginVC{
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.loginView.loginButton.layer.cornerRadius = self.viewModel.loginView.loginButton.frame.height / 2
    }
}

extension LoginVC {
    
    @objc func tappedClose() {
        self.dismiss(animated: true)
    }
    
    func onTappedLogin(){
        guard self.loginButtonLock.try() else {
            return
        }
        
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            Service.getLogger()?.debug("Cannot get device ID")
            self.loginButtonLock.unlock()
            return
        }
        
        self.setLoadingState(show: true)
        
        self.doLogin(self, loginVM: self.viewModel, deviceId: deviceId, pushTo: self.navigationController)
    }
    
    func textFieldChanged(textField: UITextField){
        var phoneNumberString = (textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? ""
        if !phoneNumberString.isEmpty { phoneNumberString.removeFirst() }
        self.viewModel.phoneNumber = phoneNumberString //(textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? ""
        self.viewModel.phoneNumberFormatted = textField.text ?? ""

        self.viewModel.loginView.loginButton.isEnabled = self.validateInputs()

        if self.viewModel.loginView.loginButton.isEnabled {
            self.viewModel.loginView.loginButton.backgroundColor = self.viewModel.loginButtonActiveBackgroundColor
            self.onTappedLogin()
        } else {
            self.viewModel.loginView.loginButton.backgroundColor = self.viewModel.loginButtonDisabledBackgroundColor
        }
    }
    
    func validateInputs() -> Bool {
        if !self.viewModel.loginView.phoneInput.isInputValidPhone() {
            return false
        }
        return true
    }
}

extension LoginVC {
    
    private func doLogin(_ loginVC: LoginVC, loginVM: LoginVM, deviceId: String, pushTo: UINavigationController? = nil) {
        self.view.endEditing(true)
        Service.getAPI()?.login(phoneNumber: loginVM.phoneNumber, deviceToken: deviceId) { [weak self] (result) in
            defer {
                self?.setLoadingState(show: false)
                self?.loginButtonLock.unlock()
            }
            
            switch result {
            case .success(let authInfo):
                
                let otpVC = OneTimePasswordVC(phoneNumberFormatted: loginVM.phoneNumberFormatted, phoneNumber: loginVM.phoneNumber, counterEndTime: authInfo.endTime, verificationCode: authInfo.verificationCode)
                                
                otpVC.viewModel.resendCallback = {
                    otpVC.setLoadingState(show: true)
                    
                    Service.getAPI()?.login(phoneNumber: loginVM.phoneNumber, deviceToken: deviceId) { result in
                        defer {
                            otpVC.setLoadingState(show: false)
                            otpVC.resendLock.unlock()
                        }
                        
                        switch result {
                        case .success(let authInfo):
                            otpVC.viewModel.counterEndTime = authInfo.endTime
                            otpVC.viewModel.verificationCode = authInfo.verificationCode
                            otpVC.viewModel.resendSuccessViewCallback?()
                        case .failure(let error):
                            Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                        }
                    }
                }
                
                otpVC.viewModel.otpEntered = self?.confirmOTPCallback(showAddCardPopup: false, viewControllerForLoading: otpVC, navigationController: pushTo ?? self?.navigationController)
                
                (pushTo ?? self?.navigationController)?.pushViewController(otpVC, animated: true)
                
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
    
    func confirmOTPCallback(showAddCardPopup: Bool, viewControllerForLoading: MIViewController? = nil, navigationController: UINavigationController? = nil) -> ((_ otpVM: OneTimePasswordVM) -> Void) {
        return {[weak self] otpVM in
            viewControllerForLoading?.setLoadingState(show: true)
            
            Service.getAPI()?.confirmAuthOTP(verificationCode: otpVM.verificationCode ?? "", smsCode: otpVM.otpCode) { (result) in
                switch result {
                case .success(let response):
                    Service.getAuthenticationManager()?.setToken(for: .AccessToken, token: response.accessToken)
                    Service.getAuthenticationManager()?.setToken(for: .RefreshToken, token: response.refreshToken)
                    
                    Service.getAPI()?.getUser { (result) in
                        defer { viewControllerForLoading?.setLoadingState(show: false) }
                        switch result {
                        case .success(let user):
                            Service.getAuthenticationManager()?.user = user
                            Service.getAuthenticationManager()?.sendAuthenticationStatusNotification(status: .LoggedIn)
                            
                            let tb = TabbarProvider.createTabbarController(delegate: nil)
                            
                            self?.navigationController?.setNavigationBarHidden(true, animated: false)
                            self?.navigationController?.pushViewController(tb, animated: true)
                            
                        case .failure(let error):
                            
                            Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                        }
                    }
                    
                case .failure(let error):
                    Service.getPopupManager()?.showErrorMessage(error)
                    viewControllerForLoading?.setLoadingState(show: false)
                    viewControllerForLoading?.view.setLoadingState(show: false)
                    Gastropay.delegate?.loginFailed(error: error)
                    guard let otpVC = viewControllerForLoading as? OneTimePasswordVC else { return }
                    if error.localizedDescription.contains("136") || error.localizedDescription.contains("tekrar otp talebinde bulununuz"){
                        otpVC.activateResend()
                    }
                    otpVC.viewModel.oneTimePassView.digitInput.reset()
                    _ = otpVC.viewModel.oneTimePassView.digitInput.becomeFirstResponder()
                }
            }
        }
    }
}

extension LoginVC: NavigationBarConfigureStyle {
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return .white
    }
}
