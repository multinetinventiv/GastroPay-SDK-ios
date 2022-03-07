//
//  MerchantList.swift
//  Networking
//
//  Created by  on 15.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import Foundation

public struct MerchantList: Codable {
    public var tagId: String
    public var tagName: String
    public var imageUrl: String
    public var merchantCount: Int
}
