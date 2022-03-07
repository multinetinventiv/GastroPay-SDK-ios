//
//  SpendableView.swift
//  Wallet
//
//  Created by  on 15.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class SpendableView: UIView {
    let container = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.Wallet.containerBackgroundColor
        $0.isSkeletonable = true
    }

    let yetlIconCoins = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Wallet.headerPuanIcon
    }

    let infoIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.info
    }

    let yetlAmount = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isSkeletonable = true
        $0.textColor = ColorHelper.Wallet.yetlDisabled
    }

    let yetlAmountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.spendableYeTLAmount.local
        $0.font = FontHelper.Wallet.yetlAmountLabel
    }

    let detailButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Wallet.spendableBalanceDetail.local, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorHelper.Wallet.yetlDetailButtonText.cgColor
        $0.setTitleColor(ColorHelper.Wallet.yetlDetailButtonText, for: .normal)
        $0.layer.cornerRadius = 18
        $0.titleLabel?.font = FontHelper.Wallet.yetlDetailButton
    }

    public var requiredBalance: String?
    public var blockedBalance: String?

    public var onTapDetail: (() -> Void)?

    init() {
        super.init(frame: .zero)
        isSkeletonable = true

        addSubview(container)
        container.addSubview(yetlIconCoins)
        container.addSubview(infoIcon)
        container.addSubview(yetlAmount)
        container.addSubview(yetlAmountLabel)
        container.addSubview(detailButton)
        detailButton.addTarget(self, action: #selector(tappedDetailButton), for: .touchUpInside)

        infoIcon.isUserInteractionEnabled = true
        infoIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoIconTapped)))

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            yetlIconCoins.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            yetlIconCoins.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            yetlIconCoins.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -16),
            yetlIconCoins.widthAnchor.constraint(equalToConstant: 100),
            yetlIconCoins.heightAnchor.constraint(equalToConstant: 111),

            infoIcon.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            infoIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            infoIcon.widthAnchor.constraint(equalToConstant: 15),
            infoIcon.heightAnchor.constraint(equalToConstant: 15),

            yetlAmount.topAnchor.constraint(equalTo: infoIcon.bottomAnchor, constant: 12),
            yetlAmount.leadingAnchor.constraint(equalTo: yetlIconCoins.trailingAnchor, constant: 32),
            yetlAmount.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16),
            yetlAmount.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            yetlAmount.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),

            yetlAmountLabel.topAnchor.constraint(equalTo: yetlAmount.bottomAnchor, constant: 6),
            yetlAmountLabel.leadingAnchor.constraint(equalTo: yetlIconCoins.trailingAnchor, constant: 32),
            yetlAmountLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            detailButton.topAnchor.constraint(equalTo: yetlAmountLabel.bottomAnchor, constant: 24),
            detailButton.leadingAnchor.constraint(equalTo: yetlIconCoins.trailingAnchor, constant: 32),
            detailButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 130),
            detailButton.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16).with({ (const) in
                const.priority = .init(251)
            }),
            detailButton.heightAnchor.constraint(equalToConstant: 36),
            detailButton.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func infoIconTapped() {
        if let requiredBalance = self.requiredBalance {
            Service.getPopupManager()?.openYeTLRequiredAmountPopup(requiredBalance: requiredBalance, blockedBalance: self.blockedBalance ?? "")
        }
    }

    @objc func tappedDetailButton() {
        onTapDetail?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        container.layer.applySketchShadow(color: ColorHelper.Wallet.yetlContainerShadowColor, alpha: 1, x: 0, y: 7, blur: 24, spread: 0, cornerRadius: 0)
    }

    public func setSpendableAmount(amount: Money) {
        let value = String(format: "%.2f", amount.value)
        let sign = amount.sign
        let fullString = "\(value) \(sign)"
        let string = NSMutableAttributedString(string: fullString)

        let valueStringRange = NSRange(location: 0, length: value.utf16.count)
        let signStringRange = NSRange(location: valueStringRange.length + 1, length: sign.utf16.count)

        string.beginEditing()

        string.addAttribute(.font, value: FontHelper.Wallet.yetlNumber, range: valueStringRange)
        string.addAttribute(.font, value: FontHelper.Wallet.yetlLabel, range: signStringRange)
        string.addAttribute(.baselineOffset, value: (FontHelper.Wallet.yetlNumber.xHeight - FontHelper.Wallet.yetlLabel.xHeight) / 2, range: signStringRange)

        string.endEditing()
        yetlAmount.attributedText = string
        yetlAmount.textColor = amount.value > 0 ? ColorHelper.Wallet.yetlActive : ColorHelper.Wallet.yetlDisabled
        yetlAmount.textColor = ColorHelper.Wallet.yetlActive
    }

}
