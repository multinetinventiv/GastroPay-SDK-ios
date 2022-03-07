//
//  CreditCard.swift
//  Shared
//
//  Created by  on 18.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct CreditCard: Codable {
    public let id: Int?
    public let alias: String?
    public let number: String?
    public let binNumber: String?
    public var isDefault: Bool?
    public var bankLogoUrl: String?
    public var paymentBrandLogoUrl: String?

    public init(id: Int, cardNumber: String, alias: String, binNumber: String, isDefault: Bool, bankLogoUrl: String?, paymentBrandLogoUrl: String?) {
        self.id = id
        self.number = cardNumber
        self.alias = alias
        self.isDefault = isDefault
        self.binNumber = binNumber
        self.bankLogoUrl = bankLogoUrl
        self.paymentBrandLogoUrl = paymentBrandLogoUrl
    }
}
