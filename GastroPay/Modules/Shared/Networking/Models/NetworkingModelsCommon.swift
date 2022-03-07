//
//  NetworkingModelsNamespace.swift
//  Shared
//
//  Created by  on 3.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public struct NetworkModels {}

public extension NetworkModels {
    struct CampaignRewardPercentage: Codable {
        public var percentage: String?

        enum CampaignRewardPercentageKeys: String, CodingKey {
            case percentage
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CampaignRewardPercentageKeys.self)
            self.percentage = try? container.decode(String.self, forKey: .percentage)
        }
    }

    struct SaveMobileDeviceInfo: Codable {
        public var userId: Int?
        public var deviceUUID: String?
        public var applicationName: String?
        public var appVersion: String?
        public var deviceToken: String?
        public var deviceName: String?
        public var deviceModel: String?
        public var os: String?
        public var osVersion: String?
    }

    struct NotificationPreference: Codable {
        public enum NotificationChannel: Int, Codable {
            case sms = 1
            case email = 2
            case push = 3
        }
        
        public var id: Int
        public var label: String
        public var channel: NotificationChannel
        public var state: Int

        public func getTitle() -> String {
            switch channel {
            case .sms:
                return Localization.Settings.notificationChannelSms.local
            case .email:
                return Localization.Settings.notificationChannelEmail.local
            case .push:
                return Localization.Settings.notificationChannelPush.local
            }
        }
    }

    struct Image: Codable {
        public var id: String?
        public var title: String?
        public var isShowcase: Bool?
        public var order: Int?
        public var url: String?
    }

    struct WalletTransactionSummary: Codable {
        public struct MonthlyInfo: Codable {
            public var month: Int?
            public var monthName: String?
            public var monthlyTotalCashback: Money?
        }

        public var totalCashback: Money?
        public var currentMonthCashBack: Money?
        public var monthlyInfo: [MonthlyInfo?]?
    }

    struct ContractLink: Codable {
        public var url: String
    }

    struct MerchantDetailed: Codable {
        public struct Tag: Codable {
            public var id: String?
            public var tagName: String?
            public var icon: Image
        }

        public struct PageContent: Codable {
            public var id: String?
            public var title: String?
            public var content: String?
            public var icon: Image?
        }

        public struct Address: Codable {
            public var id: String?
            public var city: String?
            public var district: String?
            public var neighbourhood: String?
            public var fullAddressText: String?
        }

        public var tags: [Tag]?
        public var pageContent: PageContent?
        public var address: Address?
        public var merchantId: String
        public var name: String?
        public var logoUrl: String?
        public var showcaseImageUrl: String?
        public var images: [Image]?
        public var isBonusPoint: Bool?
        public var rewardPercentage: String?
        public var distance: Int
        public var longitude: Double?
        public var latitude: Double?
        public var note: String?
        public var rate: Double?
        public var phoneNumber: String?
        public var gsmNumber: String?

        public func getShowcaseImageUrl() -> String? {
            guard let images = images else { return nil }

            for image in images {
                if image.isShowcase != nil, image.isShowcase! {
                    return image.url
                }
            }

            var minOrderValue = Int.max
            var minOrderImageUrl: String!

            for image in images {
                if image.order != nil, image.order! < minOrderValue {
                    minOrderValue = image.order!
                    minOrderImageUrl = image.url
                }
            }

            return minOrderImageUrl
        }
    }

    struct Settings: Codable {
        public var IosAppStoreUrl: String?
        public var forceUpdateMinVersionForAndroid: Int
        public var forceUpdateVersionsForAndroid: [Int]
        public var forceUpdateMinVersionForIos: String
        public var forceUpdateVersionsForIos: [String]
        public var faq: String
        public var howToUse: String
        public var phoneNumber: String
        public var whatsAppNumber: String
        public var email: String
        public var gdprUrl: String
        public var clarificationUrl: String
    }

    struct UpdateProfilePhotoResponse: Codable {
        public var imageUrl: String?
        public var thumbnailUrl: String?
    }
}
