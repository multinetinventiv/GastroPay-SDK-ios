//
//  swift
//  Gastropay
//
//  Created by Ramazan Oz on 9.09.2021.
//

import Foundation

class PaymentResultView: MIStackableView {    
    let headerContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.PaymentResult.cardBackgroundColor
    }
    
    let successIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.tick
        $0.contentMode = .scaleAspectFit
    }
    
    let paymentSuccessLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Payment.SuccessScreen.successLabel.local
        $0.font = FontHelper.PaymentResult.statusInfo
        $0.textColor = ColorHelper.PaymentResult.statusInfo
        $0.textAlignment = .center
    }
    
    let spentAmountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentResult.amount
        $0.textColor = ColorHelper.PaymentResult.amount
        $0.textAlignment = .center
    }
    
    let contactUsHeader = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Payment.SuccessScreen.experienceLabel.local
        $0.font = FontHelper.PaymentResult.contactUsHeader
        $0.textColor = ColorHelper.PaymentResult.contactUsHeader
        $0.numberOfLines = 0
    }
    
    let contactUsDesc = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Payment.SuccessScreen.experienceInfoLabel.local
        $0.font = FontHelper.PaymentResult.contactUsDesc
        $0.textColor = ColorHelper.PaymentResult.contactUsDesc
        $0.numberOfLines = 0
    }
    
    let contactUsButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Payment.SuccessScreen.contactUs.local, for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = FontHelper.PaymentResult.contactUsButton
        $0.setTitleColor(ColorHelper.PaymentResult.contactUsButton, for: .normal)
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.layer.borderColor = ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonBorder.cgColor
        $0.layer.borderWidth = 1
        $0.isEnabled = false
    }
    
    let endButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(ColorHelper.Button.textColor, for: .normal)
        $0.backgroundColor = ColorHelper.Button.backgroundColor
        $0.setTitle(Localization.Payment.SuccessScreen.end.local, for: .normal)
        $0.titleLabel?.font = FontHelper.PaymentConfirmation.Result.endButton
    }
    
    func setupView() {
        headerContainer.addSubview(successIcon)
        headerContainer.addSubview(paymentSuccessLabel)
        headerContainer.addSubview(spentAmountLabel)
        
        NSLayoutConstraint.activate([
            successIcon.heightAnchor.constraint(equalToConstant: 43),
            successIcon.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            successIcon.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            
            paymentSuccessLabel.topAnchor.constraint(equalTo: successIcon.bottomAnchor, constant: 12),
            paymentSuccessLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            paymentSuccessLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
                        
            spentAmountLabel.topAnchor.constraint(equalTo: paymentSuccessLabel.bottomAnchor, constant: 12),
            spentAmountLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            spentAmountLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            spentAmountLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -16)
        ])
        
        if #available(iOS 11.0, *) {
            stackView.contentInsetAdjustmentBehavior = .never
            successIcon.topAnchor.constraint(equalTo: headerContainer.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            successIcon.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16).isActive = true
        }
        
        stackView.addRow(headerContainer)
        stackView.setInset(forRow: headerContainer, inset: .zero)
        stackView.addRow(contactUsHeader)
        stackView.setInset(forRow: contactUsHeader, inset: UIEdgeInsets(top: 48, left: 16, bottom: 0, right: 16))
        stackView.addRow(contactUsDesc)
        stackView.addRow(contactUsButton)
        
        addSubview(endButton)
        if #available(iOS 11.0, *) {
            endButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
            endButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
            endButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            endButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            endButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            endButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        endButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stackView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
    }
}
