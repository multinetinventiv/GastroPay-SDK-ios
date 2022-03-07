//
//  Cities.swift
//  Gastropay
//
//

import Foundation

public extension NetworkModels  {
    struct Cities: Codable {
        public var cities: [City]
    }
    
    struct City: Codable {
        public var id: Int!
        public var name: String!
    }
}

