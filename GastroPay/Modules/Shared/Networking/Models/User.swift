//
//  User.swift
//  Shared
//
//  Created by  on 25.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct User: Codable {
    public var id: Int
    public var firstName: String
    public var lastName: String
    public var email: String
    public var isActive: Bool
    public var gsmNumber: String
    public var pinCodeEnabled: Bool
    public var pinCodeThresholdAmount: Money
    public var walletUId: String
    public var photoUrl: String?
    public var referralLink:String?
}
