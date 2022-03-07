//
//  Money.swift
//  Shared
//
//  Created by  on 11.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct Money: Codable {
    public var value: Double
    public var currency: String
    public var sign: String
    public var displayValue: String

    enum MoneyKeys: String, CodingKey {
        case value, currency, sign, displayValue
    }

    public init(value: Double, currency: String, sign: String, displayValue: String) {
        self.value = value
        self.currency = currency
        self.sign = sign
        self.displayValue = displayValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoneyKeys.self)
        self.value = try Double(container.decode(Double.self, forKey: .value))
        self.currency = try container.decode(String.self, forKey: .currency)
        self.sign = try container.decode(String.self, forKey: .sign)
        self.displayValue = try container.decode(String.self, forKey: .displayValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MoneyKeys.self)
        try container.encode(String(describing: value), forKey: .value)
        try container.encode(currency, forKey: .currency)
        try container.encode(sign, forKey: .sign)
        try container.encode(displayValue, forKey: .displayValue)
    }
}
