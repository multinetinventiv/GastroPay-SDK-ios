***REMOVED***
***REMOVED***  LoginViewModel.swift
***REMOVED***  Authentication
***REMOVED***
***REMOVED***  Created by  on 6.12.2019.
***REMOVED***

import Foundation

public class LoginVM {
    
    var onTapLogin: () -> ()?
    var onTextFieldDidChange: (UITextField) -> ()?
    
    public var navigationTitle: String = Localization.Authentication.Login.navigationBarTitle.local
    public var navigationTitleFont: UIFont = FontHelper.Login.navigationTitle
    public var navigationTitleTextColor: UIColor!
    
    public var navigationBackIcon: UIImage = ImageHelper.Icons.backArrow!
    
    public var welcomeHeaderText: String = Localization.Authentication.Login.welcomeHeaderText.local
    public var welcomeHeaderTextFont: UIFont = FontHelper.Login.welcomeHeader
    public var welcomeHeaderTextColor: UIColor!
    public var welcomeHeaderInfoText: String = Localization.Authentication.Login.welcomeHeaderInfoText.local
    public var welcomeHeaderInfoTextFont: UIFont = FontHelper.Login.welcomeHeaderInfo
    public var welcomeHeaderInfoTextColor: UIColor!
    
    public var phoneInputPlaceholder: String = Localization.Authentication.Login.phonePlaceholder.local
    
    public var loginButtonText: String = Localization.Authentication.Login.loginButtonText.local
    public var loginButtonFont: UIFont?
    public var loginButtonCornerRadius: CGFloat!
    
    public var loginButtonActiveTextColor: UIColor = ColorHelper.Login.loginButtonText
    public var loginButtonActiveBackgroundColor: UIColor = ColorHelper.Button.backgroundColor
    public var loginButtonDisabledTextColor: UIColor = ColorHelper.Button.textColorDisabled
    public var loginButtonDisabledBackgroundColor: UIColor = ColorHelper.Button.backgroundColorDisabled
    
    public var phoneNumberFormatted = ""
    public var phoneNumber: String = ""
    
    public var loginView: LoginView = LoginView()
    
    public init(whenLoginButtonClicked:@escaping (() -> ()), whenTextFieldChanged: @escaping ((UITextField) -> ()))
    {
        onTapLogin = whenLoginButtonClicked
        onTextFieldDidChange = whenTextFieldChanged
    }
    
    public func setupView(vc: MIViewController){
        
        loginView.navigationTitleLabel.text = self.navigationTitle
        loginView.navigationTitleLabel.font = self.navigationTitleFont
        loginView.navigationTitleLabel.textColor = self.navigationTitleTextColor
        
        loginView.welcomeHeader.text = self.welcomeHeaderText
        loginView.welcomeHeader.textColor = self.welcomeHeaderTextColor
        loginView.welcomeHeader.font = self.welcomeHeaderTextFont
        
        loginView.welcomeHeaderInfo.text = self.welcomeHeaderInfoText
        loginView.welcomeHeaderInfo.textColor = self.welcomeHeaderInfoTextColor
        loginView.welcomeHeaderInfo.font = self.welcomeHeaderInfoTextFont
        
        loginView.phoneInput.placeholder = self.phoneInputPlaceholder
        loginView.phoneInputController = MITextFieldControllerOutlined(textInput: loginView.phoneInput)
        loginView.phoneInput.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        loginView.phoneInput.becomeFirstResponder()
        
        loginView.loginButton.addTarget(self, action: #selector(onLoginClicked), for: .touchUpInside)
        loginView.loginButton.setTitle(self.loginButtonText, for: .normal)
        loginView.loginButton.titleLabel?.font = self.loginButtonFont
        loginView.loginButton.setTitleColor(self.loginButtonActiveTextColor, for: .normal)
        loginView.loginButton.backgroundColor = self.loginButtonDisabledBackgroundColor
        
        loginView.setupView()
        
        vc.view.addSubview(self.loginView)
        self.loginView.bindFrameToSuperviewBounds()
    }
    
    public func animateWithKeyboard(keyboardHeight: CGFloat, view: UIView){
        self.loginView.stackViewBottomConstraint.constant = -keyboardHeight - self.loginView.loginButton.frame.height - 32
        self.loginView.loginButtonBottomConstraint.constant = -keyboardHeight - 16
        view.layoutIfNeeded()
    }
    
}

extension LoginVM{
    
    @objc func onLoginClicked(){
        self.onTapLogin()
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        self.onTextFieldDidChange(textField)
    }
    
}
