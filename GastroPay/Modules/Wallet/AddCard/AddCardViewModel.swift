//
//  AddCardViewModel.swift
//  Wallet
//
//  Created by Emrah Multinet on 9.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

public class AddCardViewModel {
    
    public init() {}
    
    var viewBackgroundColor: UIColor = ColorHelper.Wallet.AddCard.background
    
    var navigationTitle: String = NSLocalizedString(Localization.Wallet.AddCard.navigationTitle, comment: "")
    var navigationTitleFont: UIFont = FontHelper.Wallet.AddCard.title
    var navigationTitleTextColor: UIColor = ColorHelper.Wallet.AddCard.title
    var navigationDismissIcon: UIImage = ImageHelper.Icons.close
    var navigationDismissIconTintColor: UIColor = .black
    var submitButtonTitle: String = NSLocalizedString(Localization.Wallet.AddCard.buttonTitle, comment: "")
    
    var textFieldFont: UIFont = FontHelper.Wallet.AddCard.input
    var textFieldHeight: CGFloat = UIScreen.main.bounds.height > 600 ? 50.0 : 45.0
    
    var cardOwnerPlaceholder: String = NSLocalizedString(Localization.Wallet.AddCard.cardPlaceholder, comment: "")
    var cardOwnerKeyboardType: UIKeyboardType = .default
    
    var cardNumberPlaceholder: String = NSLocalizedString(Localization.Wallet.AddCard.cardNumber, comment: "")
    var cardNumberKeyboardType: UIKeyboardType = .numberPad
    
    var expDatePlaceholder: String = NSLocalizedString(Localization.Wallet.AddCard.cardExpDate, comment: "")
    var expDateKeyboardType: UIKeyboardType = .numberPad
    
    var cvvPlaceholder: String = NSLocalizedString(Localization.Wallet.AddCard.cardCvv, comment: "")
    var cvvKeyboardType: UIKeyboardType = .numberPad
    
    var cardAliasPlaceholder: String = NSLocalizedString(Localization.Wallet.AddCard.cardNickname, comment: "")
    var cardAliasKeyboardType: UIKeyboardType = .default
    
    var cardOwner: String!
    var cardNumber: String!
    var expDate: String!
    var cvv: String!
    var cardAlias: String!

    public var showSuccessPopup = true
    public var onSuccess: ((_ card: CreditCard) -> Void)?
    public var onSuccessBeforePopupPresent: ((_ card: CreditCard) -> Void)?
    public var onSuccessPopupAction: (() -> Void)?
    public var successPopupWillHide: (() -> Void)?
    
        
    /*
      generate for mocking
     */
    public func toDict() -> [String: Any] {
        
        return [
            "cardPlaceholder": cardOwner ?? "",
            "cardNumber": cardNumber ?? "",
            "cardExpireYear": expDate ?? "",
            "cardCvv": cvv ?? "",
            "cardAlias": cardAlias ?? ""
        ]

    }
    
}
