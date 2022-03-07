//
//  RestaurantSearch.swift
//  Shared
//
//  Created by  on 12.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import Foundation

public extension NetworkModels {
    struct SearchCriteria: Codable {
        public var tagGroupName: String
        public var tagGroupKey: String
        public var tags: [SearchCriteriaItem]
    }

    struct SearchCriteriaItem: Codable {
        public var id: String
        public var tagName: String
        public var icon: Image?
        public var selected: Bool = false

        enum SearchCriteriaItemKeys: String, CodingKey {
            case id, tagName, icon
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: SearchCriteriaItemKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.tagName = try container.decode(String.self, forKey: .tagName)
            self.icon = try? container.decode(Image.self, forKey: .icon)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: SearchCriteriaItemKeys.self)
            try container.encode(self.id, forKey: .id)
            try container.encode(self.tagName, forKey: .tagName)
            try? container.encode(self.icon, forKey: .icon)
        }
    }
}
