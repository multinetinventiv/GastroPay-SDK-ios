//
//  WalletTransaction.swift
//  Shared
//
//  Created by  on 12.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

public enum WalletTransactionType: String {
    case Deposit = "10"
    case Withdraw = "20"
    case CancelDeposit = "42"
    case CancelWithdraw = "44"

    public func toDisplayValue() -> String {
        switch self {
        case .Deposit:
            return Localization.Wallet.TransactionTypeLabel.deposit.local
        case .Withdraw:
            return Localization.Wallet.TransactionTypeLabel.spending.local
        case .CancelDeposit:
            return Localization.Wallet.TransactionTypeLabel.cancel.local
        case .CancelWithdraw:
            return Localization.Wallet.TransactionTypeLabel.cancel.local
        }
    }

    public func toDisplayColor() -> UIColor {
        switch self {
        case .Deposit:
            return ColorHelper.Wallet.TransactionDetail.transactionStatusDeposit
        case .Withdraw:
            return ColorHelper.Wallet.TransactionDetail.transactionStatusWithdraw
        case .CancelDeposit:
            return ColorHelper.Wallet.TransactionDetail.transactionStatusCancel
        case .CancelWithdraw:
            return ColorHelper.Wallet.TransactionDetail.transactionStatusCancel
        }
    }
}

public enum WalletTransactionDetailType: Int {
    case Normal = 10
    case Cashback = 20
    case CreditCard = 30
    case ServiceCost = 40

    public func toDisplayValue() -> String {
        switch self {
        case .Normal:
            return Localization.Wallet.TransactionDetail.TypeLabel.normal.local
        case .Cashback:
            return Localization.Wallet.TransactionDetail.TypeLabel.cashback.local
        case .CreditCard:
            return Localization.Wallet.TransactionDetail.TypeLabel.creditCard.local
        case .ServiceCost:
            return Localization.Wallet.TransactionDetail.TypeLabel.serviceCost.local
        }
    }
}

public struct WalletTransactionDetail: Codable {
    public var id: Int
    public var transactionAmount: Money
    public var type: WalletTransactionDetailType?

    enum WalletTransactionDetailKeys: String, CodingKey {
        case id, transactionAmount, type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WalletTransactionDetailKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.transactionAmount = try container.decode(Money.self, forKey: .transactionAmount)
        self.type = try? WalletTransactionDetailType(rawValue: container.decode(Int.self, forKey: .type))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WalletTransactionDetailKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.transactionAmount, forKey: .transactionAmount)
        if let type = self.type {
            try? container.encode(Int(type.rawValue), forKey: .type)
        }
    }
}

public struct WalletTransactionInfo: Codable {
    public var channelId: Int
    public var channelName: String
}

public struct WalletTransaction: Codable {
    public var id: Int
    public var transactionAmount: Money
    public var lastWalletBalance: Money
    public var lastCashBackBalance: Money
    public var transactionDate: Date
    public var walletTransactionType: WalletTransactionType
    public var card: CreditCard
    public var merchantName: String?
    public var invoiceNumber: String?
    public var walletTransactionDetails: [WalletTransactionDetail]?

    enum WalletTransactionKeys: String, CodingKey {
        case id, transactionAmount, lastWalletBalance, lastCashBackBalance,
            transactionDate, walletTransactionType, card, merchantName, invoiceNumber, walletTransactionDetails
    }

    public init(id: Int, transactionAmount: Money, lastWalletBalance: Money, lastCashBackBalance: Money, transactionDate: Date, walletTransactionType: WalletTransactionType, card: CreditCard, merchantName: String? = nil,invoiceNumber: String? = nil, walletTransactionDetails: [WalletTransactionDetail]? = nil) {
        self.id = id
        self.transactionAmount = transactionAmount
        self.lastWalletBalance = lastWalletBalance
        self.lastCashBackBalance = lastCashBackBalance
        self.transactionDate = transactionDate
        self.walletTransactionType = walletTransactionType
        self.card = card
        self.merchantName = merchantName
        self.invoiceNumber = invoiceNumber
        self.walletTransactionDetails = walletTransactionDetails
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WalletTransactionKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.transactionAmount = try container.decode(Money.self, forKey: .transactionAmount)
        self.lastWalletBalance = try container.decode(Money.self, forKey: .lastWalletBalance)
        self.lastCashBackBalance = try container.decode(Money.self, forKey: .lastCashBackBalance)

        let transactionDate = try container.decode(String.self, forKey: .transactionDate)
        self.transactionDate = Date(timeIntervalSince1970: TimeInterval(Int(transactionDate)!))

        self.walletTransactionType = try WalletTransactionType(rawValue: container.decode(String.self, forKey: .walletTransactionType))!

        self.card = try container.decode(CreditCard.self, forKey: .card)
        self.merchantName = try? container.decode(String.self, forKey: .merchantName)
        self.invoiceNumber = try? container.decode(String.self, forKey: .invoiceNumber)
        self.walletTransactionDetails = try? container.decode([WalletTransactionDetail].self, forKey: .walletTransactionDetails)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WalletTransactionKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.transactionAmount, forKey: .transactionAmount)
        try container.encode(self.lastWalletBalance, forKey: .lastWalletBalance)
        try container.encode(self.lastCashBackBalance, forKey: .lastCashBackBalance)
        try container.encode(self.transactionDate.timeIntervalSince1970, forKey: .transactionDate)
        try container.encode(self.walletTransactionType.rawValue, forKey: .walletTransactionType)
        try container.encode(self.card, forKey: .card)
        try? container.encode(self.merchantName, forKey: .merchantName)
        try? container.encode(self.invoiceNumber, forKey: .invoiceNumber)
        try? container.encode(self.walletTransactionDetails, forKey: .walletTransactionDetails)
    }
}
