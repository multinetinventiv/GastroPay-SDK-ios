//
//  PaymentInformation.swift
//  Shared
//
//  Created by  on 3.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public enum PaymentTokenType: Int, Codable
{
    case qr = 0
    case code = 1
}

public enum CallType: Int, Codable
{
    case confirmProvision = 0
    case confirmAndCompleteProvision = 1
}

public extension NetworkModels {
    
    struct PaymentInformation: Codable {
        public var merchantId: Int
        public var merchantUid: String
        public var token: String
        public var amount: Money
        public var merchantName: String
        public var totalAmount: Money
        public var availableAmount: Money
        public var usingAvailableAmount: Money
        public var callType: CallType = CallType.confirmProvision
        public var terminalUid: String?

        enum PaymentInformationKeys: String, CodingKey {
            case merchantId, token, amount, merchantName, totalAmount, availableAmount, usingAvailableAmount, merchantUid, callType, terminalUid
        }

        init(merchantId: Int, merchantUid: String, token: String, amount: Money, merchantName: String, totalAmount: Money, availableAmount: Money, usingAvailableAmount: Money, callType: CallType = CallType.confirmProvision, terminalUid: String?) {
            self.merchantId = merchantId
            self.merchantUid = merchantUid
            self.token = token
            self.amount = amount
            self.merchantName = merchantName
            self.totalAmount = totalAmount
            self.availableAmount = availableAmount
            self.usingAvailableAmount = usingAvailableAmount
            self.callType = callType
            self.terminalUid = terminalUid
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PaymentInformationKeys.self)
            self.merchantId = try container.decode(Int.self, forKey: .merchantId)
            self.merchantUid = try container.decode(String.self, forKey: .merchantUid)
            self.merchantName = try container.decode(String.self, forKey: .merchantName)
            self.token = try container.decode(String.self, forKey: .token)
            self.amount = try container.decode(Money.self, forKey: .amount)
            self.totalAmount = try container.decode(Money.self, forKey: .totalAmount)
            self.availableAmount = try container.decode(Money.self, forKey: .availableAmount)
            self.usingAvailableAmount = try container.decode(Money.self, forKey: .usingAvailableAmount)
            self.callType = try decoder.decodeIfPresent("callType") ?? CallType.confirmProvision
            self.terminalUid = try decoder.decodeIfPresent("terminalUid")
        }
    }
}
