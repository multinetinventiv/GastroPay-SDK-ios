//
//  MonthlyAmount.swift
//  Shared
//
//  Created by Emrah Korkmaz on 26.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct MonthlyAmount: Codable {
    public var month: String!
    public var amount: TotalAmount!
}
