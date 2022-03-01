***REMOVED***
***REMOVED***  Merchant.swift
***REMOVED***  Networking
***REMOVED***
***REMOVED***  Created by  on 22.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Foundation
import Codextended

public struct MerchantResponse: Codable {
    public var isLastPage: Bool = false
    public var merchants: [Merchant] = []

    enum MerchantResponse: String, CodingKey {
        case isLastPage, merchants
    }

    init(isLastPage: Bool = false, merchants: [Merchant]) {
        self.isLastPage = isLastPage
        self.merchants = merchants
    }

    public init(from decoder: Decoder) throws {
        self.isLastPage = try decoder.decodeIfPresent(MerchantResponse.isLastPage) ?? false
        self.merchants = try decoder.decodeIfPresent(MerchantResponse.merchants) ?? []
    }
}

public struct AllMerchantsResponse: Codable {
    public var hash: String?
    public var merchants: [Merchant] = []

    enum MerchantResponse: String, CodingKey {
        case hash, merchants
    }

    init(hash: String?, merchants: [Merchant]) {
        self.hash = hash
        self.merchants = merchants
    }

    public init(from decoder: Decoder) throws {
        self.hash = try decoder.decodeIfPresent(MerchantResponse.hash)
        self.merchants = try decoder.decodeIfPresent(MerchantResponse.merchants) ?? []
    }
}

public struct Merchant: Codable {
    public var merchantId: String
    public var name: String
    public var description: String?
    public var distance: Int?
    public var discountRate: Int?
    public var imageUrl: String?
    public var latitude: Double?
    public var longitude: Double?
    public var rewardPercentage: String?
    public var images: [NetworkModels.Image]?
    public var logoUrl: String?
    public var showcaseImageUrl: String
    public var isBonusPoint: Bool?

    public func getDistanceAsMeters() -> String? {
        guard let distance = distance else { return nil }
        if distance > 900 {
            let distanceAsKM: Double = Double(distance) / 1000
            return Localization.Units.merchantDistanceLabelKM.local.replacingOccurrences(of: "%1$s", with: String(format: "%.2f", distanceAsKM))
        } else {
            return Localization.Units.merchantDistanceLabelMT.local.replacingOccurrences(of: "%1$s", with: String(distance))
        }
    }

    public func getImageUrl() -> String? {
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
