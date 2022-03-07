//
//  TransactionCell.swift
//  Wallet
//
//  Created by  on 20.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class TransactionCell: UITableViewCell {
    let merchant = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let amount = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    let transactionType = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let transactionDateFormatter = DateFormatter().then { $0.dateFormat = "dd.MM.YYY - HH:mm" }
    let date = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    let chevron = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        let nameAndAliasContainer = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        let amountAndDateContainer = UIView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(nameAndAliasContainer)
        contentView.addSubview(amountAndDateContainer)
        nameAndAliasContainer.addSubview(merchant)
        nameAndAliasContainer.addSubview(transactionType)
        amountAndDateContainer.addSubview(amount)
        amountAndDateContainer.addSubview(date)
        contentView.addSubview(chevron)

        NSLayoutConstraint.activate([
            nameAndAliasContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameAndAliasContainer.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            nameAndAliasContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            merchant.topAnchor.constraint(equalTo: nameAndAliasContainer.topAnchor),
            merchant.leadingAnchor.constraint(equalTo: nameAndAliasContainer.leadingAnchor),
            merchant.trailingAnchor.constraint(equalTo: nameAndAliasContainer.trailingAnchor),

            transactionType.topAnchor.constraint(equalTo: merchant.bottomAnchor, constant: 4),
            transactionType.leadingAnchor.constraint(equalTo: nameAndAliasContainer.leadingAnchor),
            transactionType.trailingAnchor.constraint(equalTo: nameAndAliasContainer.trailingAnchor),
            transactionType.bottomAnchor.constraint(equalTo: nameAndAliasContainer.bottomAnchor),


            amountAndDateContainer.leadingAnchor.constraint(equalTo: nameAndAliasContainer.trailingAnchor),
            amountAndDateContainer.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            amountAndDateContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            amountAndDateContainer.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),

            amount.topAnchor.constraint(equalTo: amountAndDateContainer.topAnchor),
            amount.leadingAnchor.constraint(equalTo: amountAndDateContainer.leadingAnchor),
            amount.trailingAnchor.constraint(equalTo: amountAndDateContainer.trailingAnchor),

            date.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: 4),
            date.leadingAnchor.constraint(equalTo: amountAndDateContainer.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: amountAndDateContainer.trailingAnchor),
            date.bottomAnchor.constraint(equalTo: amountAndDateContainer.bottomAnchor),

            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.widthAnchor.constraint(equalToConstant: 6),
            chevron.heightAnchor.constraint(equalToConstant: 12),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for transaction: WalletTransaction) {
        amount.text = transaction.transactionAmount.displayValue
        date.text = transactionDateFormatter.string(from: transaction.transactionDate)
        merchant.text = transaction.merchantName
    }
}
