//
//  RegisterVM.swift
//  Authentication
//
//  Created by  on 16.12.2019.
//

import Foundation


public class RegisterVM {
    public var welcomeText: String = "Hoşgeldiniz"
    public var welcomeTextColor: UIColor!
    public var welcomeFont: UIFont!

    public var welcomeInfoText: String = "Gerçekbir kişi olduğunuzu teyit edebilmemiz için lütfen aşağıdaki bilgileri giriniz."
    public var welcomeInfoTextColor: UIColor!
    public var welcomeInfoFont: UIFont!

    public var nameInputPlaceholder: String = "AD"
    public var surnameInputPlaceholder: String = "SOYAD"
    public var phoneInputPlaceholder: String = "CEP TELEFONU"
    public var emailInputPlaceholder: String = "E-MAİL ADRESİ"
    public var davetiyeInputPlaceholder: String = "DAVETİYE KODU"

    public var checkboxMarkColor: UIColor = UIColor(red: 255 / 255, green: 202 / 255, blue: 40 / 255, alpha: 1.0)
    public var checkboxActiveBorderColor: UIColor = UIColor(red: 255 / 255, green: 202 / 255, blue: 40 / 255, alpha: 1.0)
    public var checkboxBorderColor: UIColor = UIColor(red: 214 / 255, green: 214 / 255, blue: 214 / 255, alpha: 1.0)
    public var checkboxStyle: MICheckBox.Style = .fullSquareWithTick
    public var checkboxBorderStyle: MICheckBox.BorderStyle = .roundedSquare(radius: 3)

    public var checkboxLabelTextColor: UIColor!
    public var checkboxLabelFont: UIFont!

    public var checkboxPrivacyLabelText: String = "\"Kullanıcı sözleşmesi ve Gizlilik Politikasını\" okudum kabul ediyorum."
    public var checkboxPrivacyLabelLinkSubstring: String = "Kullanıcı sözleşmesi ve Gizlilik Politikasını"
    public var checkboxGdprLabelText: String = "Kişisel verilerimin, Aydınlatma Metni kapsamında işlenmesine ve aktarılmasına açık rıza veriyorum."
    public var checkboxGdprLabelLinkSubstring1: String = "Aydınlatma Metni"
    public var checkboxGdprLabelLinkSubstring2: String = "açık rıza"
    public var checkboxContactPermissionText: String = "Restoran indirimleri ve kampanyalardan haberdar olmak istiyorum."

    public var registerButtonText: String = "ÜCRETSİZ ÜYE OL"
    public var registerButtonActiveBackgroundColor: UIColor!
    public var registerButtonDisabledBackgroundColor: UIColor!
    public var registerButtonActiveTextColor: UIColor!
    public var registerButtonDisabledTextColor: UIColor!
    public var registerButtonFont: UIFont!

    public var closeIconForNavigationRoot: UIImage!
    public var backIconForNavigation: UIImage!

    public var userName: String = ""
    public var userSurname: String = ""
    public var userEmail: String = ""
    public var userPhone: String = ""
    public var userPhoneFormatted: String = ""
    public var checkedNotificationConsent: Bool = false
    public var checkedTermsAndAggreements: Bool = false
    public var checkedGdpr: Bool = false
    public var referrerProfileCode:Int?

    public var showCloseIcon: Bool = false

    public var onTapLogin: (() -> Void)?
    public var onTapRegister: ((_ viewModel: RegisterVM) -> Void)?
    public var onTapPrivacyLink: (() -> Void)?
    public var onTapClarificationTextLink: (() -> Void)?
    public var onTapExplicitConsentLink: (() -> Void)?

    public init() {}

}
