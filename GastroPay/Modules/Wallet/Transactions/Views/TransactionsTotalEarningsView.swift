***REMOVED***
***REMOVED***  TransactionsTotalEarningsView.swift
***REMOVED***  Wallet
***REMOVED***
***REMOVED***  Created by  on 24.08.2020.
***REMOVED***  Copyright © 2020 Inventiv. All rights reserved.
***REMOVED***

import UIKit
import Then

class TransactionsTotalEarningsView: UIView {
    let puanIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    let totalEarningsValueLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    let totalEarningsTextLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }

    var totalEarningsPuanValueFont = FontHelper.Wallet.PuanDetail.puanValue
    var totalEarningsPuanCurrencyFont = FontHelper.Wallet.PuanDetail.puanCurrency

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(puanIcon)
        addSubview(totalEarningsValueLabel)
        addSubview(totalEarningsTextLabel)

        NSLayoutConstraint.activate([
            puanIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 140/375),
            puanIcon.heightAnchor.constraint(equalTo: puanIcon.widthAnchor, multiplier: 125/140),
            puanIcon.topAnchor.constraint(equalTo: topAnchor),
            puanIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            totalEarningsValueLabel.topAnchor.constraint(equalTo: topAnchor),
            totalEarningsValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalEarningsValueLabel.trailingAnchor.constraint(equalTo: puanIcon.leadingAnchor, constant: -16),

            totalEarningsTextLabel.topAnchor.constraint(equalTo: totalEarningsValueLabel.bottomAnchor, constant: 4),
            totalEarningsTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalEarningsTextLabel.trailingAnchor.constraint(equalTo: puanIcon.leadingAnchor, constant: -16),

            bottomAnchor.constraint(greaterThanOrEqualTo: totalEarningsTextLabel.bottomAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: puanIcon.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateTotalEarnings(with walletTransactionSummary: NetworkModels.WalletTransactionSummary) {
        let valueString = NSMutableAttributedString(string: walletTransactionSummary.totalCashback?.displayValue ?? "")
        let valueStringParts = walletTransactionSummary.totalCashback?.displayValue.split(separator: " ")

        guard let valueRange = walletTransactionSummary.totalCashback?.displayValue.range(of: valueStringParts?[0] ?? "") else { return }
        guard let signRange = walletTransactionSummary.totalCashback?.displayValue.range(of: valueStringParts?[1] ?? "") else { return }

        valueString.addAttributes([NSAttributedString.Key.font: totalEarningsPuanValueFont], range: valueRange.nsRange)
        valueString.addAttributes([NSAttributedString.Key.font: totalEarningsPuanCurrencyFont, NSAttributedString.Key.baselineOffset: ceil((totalEarningsPuanValueFont.xHeight - totalEarningsPuanCurrencyFont.xHeight) / 2)], range: signRange.nsRange)
        totalEarningsValueLabel.attributedText = valueString
        totalEarningsValueLabel.layoutIfNeeded()
    }

}
