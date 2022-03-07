//
//  TransactionDetailCell.swift
//  Gastropay
//
//  Created by on 17.09.2021.
//

import Foundation

class TransactionDetailCell: UITableViewCell {
    let label = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.TransactionDetail.billLabel.local
        $0.font = FontHelper.Wallet.TransactionDetail.rowLabel
        $0.textColor = ColorHelper.Wallet.TransactionDetail.labelColor
    }

    let value = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Wallet.TransactionDetail.rowValue
        $0.textColor = ColorHelper.Wallet.TransactionDetail.dataColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = ColorHelper.Wallet.TransactionDetail.containerBackground

        contentView.addSubview(label)
        contentView.addSubview(value)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            value.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 16),
            value.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            value.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            value.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
