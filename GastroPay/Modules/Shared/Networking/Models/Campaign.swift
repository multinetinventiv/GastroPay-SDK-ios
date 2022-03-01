***REMOVED***
***REMOVED***  Campaign.swift
***REMOVED***  Networking
***REMOVED***
***REMOVED***  Created by  on 8.11.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Foundation

public enum CampaignType: Int, Codable {
    case creditCard = 2
}

public enum CampaignRedirectionType: Int, Codable {
    case unknown = 0
    case none = 1
    case payment = 2
    case merchantList = 3
    case inviteFriend = 4
}

public struct Campaign: Codable {
    public var campaignId: Int
    public var merchantId: Int
    public var imageUrl: String
    public var visibleOnDashboard: Bool
    public var redirectionType: CampaignRedirectionType
    public var description: String?
    public var descriptionHtml: String?
    public var order: Int
    public var title: String?
    public var rewardPercentage: Int
    public var endTime: Date

    enum CampaignKeys: String, CodingKey {
        case campaignId, merchantId, imageUrl, visibleOnDashboard, redirectionType, description, descriptionHtml, order, title, rewardPercentage, endTime
    }

    public init(campaignId: Int, merchantId: Int, imageUrl: String, visibleOnDashboard: Bool, redirectionType: CampaignRedirectionType, description: String?, order: Int, title: String?, rewardPercentage: Int, endTime: Date) {
        self.campaignId = campaignId
        self.merchantId = merchantId
        self.imageUrl = imageUrl
        self.visibleOnDashboard = visibleOnDashboard
        self.redirectionType = redirectionType
        self.description = description
        self.order = order
        self.title = title
        self.rewardPercentage = rewardPercentage
        self.endTime = endTime
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CampaignKeys.self)
        self.campaignId = try container.decode(Int.self, forKey: .campaignId)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.visibleOnDashboard = try container.decode(Bool.self, forKey: .visibleOnDashboard)
        self.redirectionType = try container.decode(CampaignRedirectionType.self, forKey: .redirectionType)
        self.description = try container.decode(String.self, forKey: .description)
        self.descriptionHtml = try container.decode(String.self, forKey: .descriptionHtml)
        self.order = try container.decode(Int.self, forKey: .order)
        self.title = try container.decode(String.self, forKey: .title)
        let rewardPercentageString = try? container.decode(String.self, forKey: .rewardPercentage)
        self.rewardPercentage = Int(rewardPercentageString ?? "") ?? 0
        let endTimestampString = try container.decode(String.self, forKey: .endTime)
        self.endTime = Date(timeIntervalSince1970: TimeInterval(Int(endTimestampString)!))
    }
}
