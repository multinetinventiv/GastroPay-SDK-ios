//
//  AuthBeforeOtpResponse.swift
//  Shared
//
//  Created by  on 6.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation
import Codextended

public struct AuthBeforeOtpResponse: Codable {
    public var endTime: Date
    public var verificationCode: String?

    enum AuthBeforeOtpResponseCodingKeys: String, CodingKey {
        case endTime, verificationCode
    }

    init(endTime: Date, verificationCode: String) {
        self.endTime = endTime
        self.verificationCode = verificationCode
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthBeforeOtpResponseCodingKeys.self)
        let endTimestamp = try container.decode(String.self, forKey: .endTime)

        self.endTime = Date(timeIntervalSince1970: TimeInterval(Int(endTimestamp)!))
        self.verificationCode = try decoder.decodeIfPresent(AuthBeforeOtpResponseCodingKeys.verificationCode)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AuthBeforeOtpResponseCodingKeys.self)
        try container.encode(Int(endTime.timeIntervalSince1970), forKey: .endTime)
        try container.encode(verificationCode, forKey: .verificationCode)
    }
}
