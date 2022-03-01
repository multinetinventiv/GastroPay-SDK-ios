***REMOVED***
***REMOVED***  PaymentAmountInfo.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***  Created by Hasan Hüseyin Gücüyener on 3.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

enum PaymentInfoCellType {
    case infoLabel
    case labelWithValue
    case labelWithLoading
}

class PaymentInfoCell: UIView {
    let loadingView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.color = .gray
    }

    let label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    let infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    let value = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    init(withType: PaymentInfoCellType) {
        super.init(frame: .zero)
        initViews(withType: withType)
    }

    func updateType(with type: PaymentInfoCellType) {
        label.removeFromSuperview()
        value.removeFromSuperview()
        loadingView.removeFromSuperview()
        infoLabel.removeFromSuperview()

        initViews(withType: type)
    }

    func initViews(withType: PaymentInfoCellType) {
        switch withType {
        case .infoLabel:
            addSubview(infoLabel)
            NSLayoutConstraint.activate([
                infoLabel.topAnchor.constraint(equalTo: topAnchor),
                infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        case .labelWithValue:
            addSubview(label)
            addSubview(value)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),

                value.topAnchor.constraint(equalTo: label.topAnchor),
                value.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor),
                value.trailingAnchor.constraint(equalTo: trailingAnchor),
                value.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            ])
        case .labelWithLoading:
            addSubview(label)
            addSubview(loadingView)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),

                loadingView.topAnchor.constraint(equalTo: label.topAnchor),
                loadingView.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor),
                loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
                loadingView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            ])

            loadingView.startAnimating()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class PaymentAmountInfo: UIView {
    let orderInfoCell = PaymentInfoCell(withType: .labelWithValue).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.label.text = Localization.Payment.InfoScreen.orderAmount.local
        $0.label.font = FontHelper.PaymentConfirmation.PaymentInfo.orderInfoLabel
        $0.label.textColor = ColorHelper.PaymentConfirmation.summaryOrderLabel
        $0.value.font = FontHelper.PaymentConfirmation.PaymentInfo.orderInfoValue
        $0.value.textColor = ColorHelper.PaymentConfirmation.summaryOrderAmount
    }

    let spendingInfoCell = PaymentInfoCell(withType: .labelWithValue).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.label.text = Localization.Payment.InfoScreen.spendingAmount.local
        $0.label.font = FontHelper.PaymentConfirmation.PaymentInfo.spendingInfoLabel
        $0.label.textColor = ColorHelper.PaymentConfirmation.summarySpendingLabel
        $0.value.font = FontHelper.PaymentConfirmation.PaymentInfo.spendingInfoValue
        $0.value.textColor = ColorHelper.PaymentConfirmation.summarySpendingAmount
    }

    let totalInfoCell = PaymentInfoCell(withType: .labelWithValue).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.label.text = Localization.Payment.InfoScreen.totalAmount.local
        $0.label.font = FontHelper.PaymentConfirmation.PaymentInfo.totalInfoLabel
        $0.label.textColor = ColorHelper.PaymentConfirmation.summaryTotalLabel
        $0.value.font = FontHelper.PaymentConfirmation.PaymentInfo.totalInfoValue
        $0.value.textColor = ColorHelper.PaymentConfirmation.summaryTotalAmount
    }

    init(paymentInformation: NetworkModels.PaymentInformation) {
        super.init(frame: .zero)

        backgroundColor = .white

        insertSubview(orderInfoCell, at: 0)
        insertSubview(spendingInfoCell, at: 1)
        insertSubview(totalInfoCell, at: 2)

        NSLayoutConstraint.activate([
            orderInfoCell.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            orderInfoCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            orderInfoCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            spendingInfoCell.topAnchor.constraint(equalTo: orderInfoCell.bottomAnchor, constant: 12),
            spendingInfoCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            spendingInfoCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            totalInfoCell.topAnchor.constraint(equalTo: spendingInfoCell.bottomAnchor, constant: 12),
            totalInfoCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalInfoCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalInfoCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWithModel(paymentInformation: NetworkModels.PaymentInformation, spendYetlState: Bool = false, fetchedRewardPercentage: Bool = false) {
        orderInfoCell.value.text = paymentInformation.amount.displayValue
        spendingInfoCell.value.text = spendYetlState ? paymentInformation.usingAvailableAmount.displayValue : "-"
        totalInfoCell.value.text = paymentInformation.totalAmount.displayValue
    }

}
