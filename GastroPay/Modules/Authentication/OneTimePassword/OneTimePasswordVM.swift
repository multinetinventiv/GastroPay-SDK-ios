//
//  OTPVM.swift
//  Alamofire
//
//  Created by  on 16.12.2019.
//

import Foundation

public enum OneTimePasswordLayoutType {
    case generalWithHeader
    case general
}

public class OneTimePasswordVM {
    

    public var navigationBackButtonImage: UIImage! = ImageHelper.Icons.backArrow
    
    public var navigationTitleText: String! = Localization.Authentication.Login.navigationBarTitle.local
    public var navigationTitleFont: UIFont! = FontHelper.Navigation.title
    public var navigationTitleColor: UIColor! = ColorHelper.Login.navigationTitle
    
    public var otpType: OneTimePasswordLayoutType = .generalWithHeader
    
    public var headerText: String! = Localization.Authentication.OneTimePassword.welcomeTitle.local
    public var headerFont: UIFont! = FontHelper.OneTimePassword.welcomeHeader
    public var headerTextColor: UIColor!
    
    public var infoText: String! = Localization.Authentication.OneTimePassword.welcomeDescription.local
    public var infoFont: UIFont! = FontHelper.OneTimePassword.welcomeInfo
    public var infoTextColor: UIColor!
    
    public var counterInfoText: String! = Localization.Authentication.OneTimePassword.counterText.local
    public var counterInfoFont: UIFont! = FontHelper.OneTimePassword.countLabel
    public var counterInfoTextColor: UIColor!
    
    public var digitInputLabelText: String! = Localization.Authentication.OneTimePassword.digitInputLabel.local
    public var digitInputLabelFont: UIFont! = FontHelper.OneTimePassword.digitInputLabel
    public var digitInputLabelTextColor: UIColor!
    
    public var resendButtonText: String! = Localization.Authentication.OneTimePassword.resendButtonText.local
    public var resendButtonFont: UIFont! = FontHelper.Navigation.title
    public var resendButtonActiveBackgroundColor: UIColor! = ColorHelper.Button.backgroundColor
    public var resendButtonDisabledBackgroundColor: UIColor! = ColorHelper.Button.backgroundColorDisabled
    public var resendButtonActiveTextColor: UIColor! = ColorHelper.Button.textColor
    public var resendButtonDisabledTextColor: UIColor! = ColorHelper.Button.textColorDisabled
    
    public var phoneNumber: String!
    public var phoneNumberFormatted: String!
    
    public var counterEndTime: Date!
    
    public var verificationCode: String?
    public var otpCode: String!
    
    public var otpEntered: ((_ viewModel: OneTimePasswordVM) -> Void)!
    public var resendCallback: (() -> Void)!
    public var resendSuccessViewCallback: (() -> Void)!
    
    public var oneTimePassView = OneTimePasswordView()
    
    public var onTapResend: (() -> ())?
    public var onSetLoadingState: ((Bool) -> ())? = nil

    public init(whenResendClicked: (() -> ())?) {
        
        onTapResend = whenResendClicked
    }
    
    public func initViews(view: UIView) {
        oneTimePassView.labelWelcome.text = self.headerText
        oneTimePassView.labelWelcome.font = self.headerFont
        oneTimePassView.labelWelcome.textColor = self.headerTextColor
        
        if self.infoText.contains("%1$s") {
            oneTimePassView.labelWelcomeInfo.text = self.infoText.replacingOccurrences(of: "%1$s", with: self.phoneNumberFormatted)
        } else {
            oneTimePassView.labelWelcomeInfo.text = self.infoText
        }
        
        oneTimePassView.labelWelcomeInfo.font = self.infoFont
        oneTimePassView.labelWelcomeInfo.textColor = self.infoTextColor
        
        oneTimePassView.labelCountInfo.font = self.counterInfoFont
        oneTimePassView.labelCountInfo.textColor = self.counterInfoTextColor
        
        oneTimePassView.digitInputLabel.text = self.digitInputLabelText
        oneTimePassView.digitInputLabel.font = self.digitInputLabelFont
        oneTimePassView.digitInputLabel.textColor = self.digitInputLabelTextColor
        
        oneTimePassView.resendButton.setTitle(self.resendButtonText, for: .normal)
        oneTimePassView.resendButton.setTitleColor(self.resendButtonActiveTextColor, for: .normal)
        oneTimePassView.resendButton.setTitleColor(self.resendButtonDisabledTextColor, for: .disabled)
        oneTimePassView.resendButton.titleLabel?.font = self.resendButtonFont
        oneTimePassView.resendButton.backgroundColor = self.resendButtonDisabledBackgroundColor
        oneTimePassView.resendButton.addTarget(self, action: #selector(onTapResendClicked), for: .touchUpInside)
        
        oneTimePassView.setupView()
        
        view.addSubview(oneTimePassView)
        oneTimePassView.bindFrameToSuperviewBounds()
    }
    
    public func animateWithKeyboard(keyboardHeight: CGFloat, view: UIView){
        self.oneTimePassView.stackViewBottomConstraint.constant = -keyboardHeight - self.oneTimePassView.resendButton.frame.height - 32
        self.oneTimePassView.resendButtonBottomConstraint.constant = -keyboardHeight - 16
        view.layoutIfNeeded()
        self.oneTimePassView.stackView.scrollRowToVisible(self.oneTimePassView.digitInput)
    }
    
}

extension OneTimePasswordVM{
    
    @objc func onTapResendClicked(){
        onTapResend?()
    }
    
}
