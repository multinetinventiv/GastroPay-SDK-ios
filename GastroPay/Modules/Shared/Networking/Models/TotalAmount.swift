//
//  TotalAmount.swift
//  Shared
//
//  Created by Emrah Korkmaz on 26.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct TotalAmount: Codable {
    public var value: String!
    public var currency: String!
    public var sign: String!
    public var displayValue: String!
}
