***REMOVED***
***REMOVED***  ExpendableBalance.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***  Created by Hasan Hüseyin Gücüyener on 24.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

class ExpendableBalance: UIView {
    let containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.PaymentConfirmation.ExpendableBalance.containerBackground
    }

    let expendableBalanceLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.ExpendableBalance.expendableLabelFont
        $0.text = Localization.Payment.InfoScreen.spendableAmountLabel.local
        $0.textColor = ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceLabelText
    }

    let expendableAmount = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.ExpendableBalance.expendableValueFont
        $0.textColor = ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceText
    }

    let circularYeTL = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.puanGreen
    }

    let spendButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Payment.InfoScreen.spendableButtonText.local, for: .normal)
        $0.setTitle(Localization.Payment.InfoScreen.spendableButtonActiveText.local, for: .selected)
        $0.setTitleColor(ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonText, for: .normal)
        $0.setTitleColor(ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonTextActive, for: .selected)
        $0.titleLabel?.font = FontHelper.PaymentConfirmation.ExpendableBalance.spendButtonTitle
        $0.backgroundColor = .clear
        $0.layer.borderColor = ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonBorder.cgColor
        $0.layer.borderWidth = 1
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
    }

    var onTapStateButton: ((_ spending: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews() {
        let expendableBalance = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        spendButton.addTarget(self, action: #selector(onTapSpend), for: .touchUpInside)

        addSubview(containerView)

        containerView.addSubview(expendableBalance)
        expendableBalance.addSubview(expendableBalanceLabel)
        expendableBalance.addSubview(expendableAmount)
        expendableBalance.addSubview(circularYeTL)
        containerView.addSubview(spendButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            circularYeTL.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            circularYeTL.widthAnchor.constraint(equalToConstant: 40),
            circularYeTL.heightAnchor.constraint(equalToConstant: 40),
            circularYeTL.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            circularYeTL.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: circularYeTL.heightAnchor, multiplier: 1, constant: 20),

            expendableBalance.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            expendableBalance.leadingAnchor.constraint(equalTo: circularYeTL.trailingAnchor, constant: 5),
            expendableBalance.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),
            expendableBalance.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: expendableBalance.heightAnchor, multiplier: 1, constant: 20),

            expendableBalanceLabel.topAnchor.constraint(equalTo: expendableBalance.topAnchor),
            expendableBalanceLabel.leadingAnchor.constraint(equalTo: expendableBalance.leadingAnchor),

            expendableAmount.leadingAnchor.constraint(equalTo: expendableBalance.leadingAnchor),
            expendableAmount.topAnchor.constraint(equalTo: expendableBalanceLabel.bottomAnchor),
            expendableAmount.bottomAnchor.constraint(equalTo: expendableBalance.bottomAnchor),

            spendButton.leadingAnchor.constraint(greaterThanOrEqualTo: expendableBalance.trailingAnchor, constant: 10),
            spendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            spendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])

        containerView.layer.applySketchShadow(
            color: ColorHelper.PaymentConfirmation.ExpendableBalance.containerShadow,
            alpha: 1, x: 0, y: 7, blur: 34, spread: 0, cornerRadius: 10
        )
    }

    @objc func onTapSpend() {
        spendButton.isSelected = !spendButton.isSelected
        spendButton.layer.borderColor = (spendButton.isSelected ? ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonBorderActive : ColorHelper.PaymentConfirmation.ExpendableBalance.spendButtonBorder).cgColor
        circularYeTL.image = spendButton.isSelected ? ImageHelper.Icons.puanYellow : ImageHelper.Icons.puanGreen
        containerView.backgroundColor = spendButton.isSelected ? ColorHelper.PaymentConfirmation.ExpendableBalance.containerBackgroundSpend : ColorHelper.PaymentConfirmation.ExpendableBalance.containerBackground
        expendableBalanceLabel.textColor = spendButton.isSelected ? ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceLabelTextSpend : ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceLabelText
        expendableAmount.textColor = spendButton.isSelected ? ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceTextSpend : ColorHelper.PaymentConfirmation.ExpendableBalance.expendableBalanceText
        expendableBalanceLabel.text = spendButton.isSelected ? Localization.Payment.InfoScreen.spendingAmountLabel.local : Localization.Payment.InfoScreen.spendableAmountLabel.local
        onTapStateButton?(spendButton.isSelected)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        spendButton.layoutIfNeeded()
        spendButton.layer.cornerRadius = spendButton.frame.height / 2
    }

    func updateWithModel(paymentInformation: NetworkModels.PaymentInformation, isSpending: Bool = false) {
        self.expendableAmount.text = isSpending ? paymentInformation.usingAvailableAmount.displayValue : paymentInformation.availableAmount.displayValue

    }

}
