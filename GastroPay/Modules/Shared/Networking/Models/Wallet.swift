//
//  Wallet.swift
//  Shared
//
//  Created by  on 11.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct Wallet: Codable {
    public var walletUId: String
    public var cashBackBalance: Money
    public var availableBalance: Money
    public var minimumRequiredBalance: Money
    public var blockedBalance: Money
    public var walletTemplate: WalletTemplate
}

public struct WalletTemplate: Codable {
    public var id: Int
    public var name: String
    public var unit: WalletUnit
}

public struct WalletUnit: Codable {
    public var id: Int
    public var code: String
    public var name: String
    public var symbol: String
}
