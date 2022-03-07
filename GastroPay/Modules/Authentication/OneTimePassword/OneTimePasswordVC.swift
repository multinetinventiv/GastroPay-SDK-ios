//
//  OTPVC.swift
//  Alamofire
//
//  Created by  on 16.12.2019.
//

import UIKit
import YPNavigationBarTransition
import Then

public class OneTimePasswordVC: MIViewController {
    weak var timer: Timer?
    public var viewModel: OneTimePasswordVM!
    public let resendLock = NSLock()

    public init(otpVM: OneTimePasswordVM? = nil, phoneNumberFormatted: String? = nil, phoneNumber:String? = nil, counterEndTime:Date? = nil, verificationCode:String? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let vm = otpVM{
            viewModel = vm
        }
        else{
            
            let otpVM = OneTimePasswordVM(whenResendClicked: {
                self.onTapResend()
            })
            
            otpVM.phoneNumberFormatted = phoneNumberFormatted
            otpVM.phoneNumber = phoneNumber
            otpVM.counterEndTime = counterEndTime
            otpVM.verificationCode = verificationCode
            
            viewModel = otpVM
        }
        
        viewModel.resendSuccessViewCallback = initCounter
        viewModel.onSetLoadingState = { show in
            self.view.setLoadingState(show: show)
        }
        viewModel.initViews(view: self.view)
        
        updateCountdownLabel(with: Int(self.viewModel.counterEndTime.timeIntervalSince(Date())))
        startTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        navigationItem.title = viewModel.navigationTitleText

        animateWithKeyboard { keyboardHeight in
            self.viewModel.animateWithKeyboard(keyboardHeight: keyboardHeight, view: self.view)
        }

        self.viewModel.oneTimePassView.digitInput.delegate = self

        _ = self.viewModel.oneTimePassView.digitInput.becomeFirstResponder()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //digitInput.becomeFirstResponder()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.viewModel.oneTimePassView.resendButton.layer.cornerRadius = self.viewModel.oneTimePassView.resendButton.frame.height / 2
    }

    deinit {
        timer?.invalidate()
    }
    
    public func activateResend(){
        timer?.invalidate()
        self.viewModel.oneTimePassView.resendButton.backgroundColor = self.viewModel.resendButtonActiveBackgroundColor
        self.viewModel.oneTimePassView.resendButton.isEnabled = true
        self.updateCountdownLabel(with: 0)
        self.viewModel.oneTimePassView.digitInput.reset()
    }
    
    func getRemainingTime() -> Int {
        return Int(self.viewModel.counterEndTime.timeIntervalSince(Date()))
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (timer) in
            guard let self = self else {
                return
            }

            let remainingSeconds = self.getRemainingTime()

            if remainingSeconds <= 0 {
                self.activateResend()
                return
            }

            self.updateCountdownLabel(with: remainingSeconds)
        })
    }

    @objc func onTapResend() {
        if resendLock.try(){
            viewModel.resendCallback?()
        }
    }

    func initCounter() {
        updateCountdownLabel(with: getRemainingTime())
        self.viewModel.oneTimePassView.resendButton.backgroundColor = self.viewModel.resendButtonDisabledBackgroundColor
        self.viewModel.oneTimePassView.resendButton.isEnabled = false
        startTimer()
    }
    
    var lastUpdateCountdownNumber:Int?

    func updateCountdownLabel(with: Int) {
        lastUpdateCountdownNumber = with
        self.viewModel.oneTimePassView.labelCountInfo.text = viewModel.counterInfoText.replacingOccurrences(of: "%1$s", with: String(with))
    }

}

extension OneTimePasswordVC: DigitInputViewDelegate {

    public func digitsDidChange(digitInputView: DigitInputView) {
        let code = digitInputView.text

        viewModel.otpCode = code

        if code.count == 6, self.getRemainingTime() > 0, lastUpdateCountdownNumber ?? 0 > 0{
            viewModel.otpEntered(self.viewModel)
            self.viewModel.oneTimePassView.digitInput.endEditing(true)
        }
        else if self.getRemainingTime() <= 0 || lastUpdateCountdownNumber ?? 0 <= 0{
            activateResend()
        }
    }
}

extension OneTimePasswordVC: NavigationBarConfigureStyle{
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }
    
}
