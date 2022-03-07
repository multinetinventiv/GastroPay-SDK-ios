//
//  PaymentConfirmationMerchantInfo.swift
//  Payment
//
//  Created by Hasan Hüseyin Gücüyener on 22.12.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit
import Then

class MerchantInfoView: UIView {
    let labelPriceToPay = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.MerchantInfo.priceToPayLabel
        $0.textColor = ColorHelper.PaymentConfirmation.MerchantInfo.priceToPayText
        $0.textAlignment = .center
        $0.text = Localization.Payment.InfoScreen.amountToPay.local
        $0.numberOfLines = 0
    }

    let labelPrice = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.MerchantInfo.priceToPayValue
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PaymentConfirmation.MerchantInfo.priceText
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        backgroundColor = ColorHelper.PaymentConfirmation.MerchantInfo.backgroundColor
        
        addSubview(labelPriceToPay)
        addSubview(labelPrice)

        NSLayoutConstraint.activate([
            labelPriceToPay.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelPriceToPay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            labelPrice.topAnchor.constraint(equalTo: labelPriceToPay.bottomAnchor, constant: 4),
            labelPrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelPrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        if #available(iOS 11.0, *) {
            labelPriceToPay.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        } else {
            labelPriceToPay.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
