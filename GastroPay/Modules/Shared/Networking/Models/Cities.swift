***REMOVED***
***REMOVED***  Cities.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

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

