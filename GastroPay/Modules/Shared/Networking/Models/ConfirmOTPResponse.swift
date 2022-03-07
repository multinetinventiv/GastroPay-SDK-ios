//
//  Authentication.swift
//  Shared
//
//  Created by  on 17.12.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import Foundation

public struct ConfirmOTPResponse: Codable {
    public var accessToken: String
    public var refreshToken: String

    enum AuthenticationKeys: String, CodingKey {
        case userToken, refreshToken
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthenticationKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .userToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AuthenticationKeys.self)
        try container.encode(accessToken, forKey: .userToken)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}
