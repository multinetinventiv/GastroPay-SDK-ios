***REMOVED***
***REMOVED***  SelectedCityModel.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Copyright © 2021 Multinet. All rights reserved.
***REMOVED***

import Foundation
public struct SelectedCityModel {
    var city: NetworkModels.City
    var region: NetworkModels.SearchCriteriaItem?
    
    public init(city: NetworkModels.City, region: NetworkModels.SearchCriteriaItem? = nil) {
        self.city = city
        self.region = region
    }
    
    public func getCity() -> NetworkModels.City {
        return city
    }
    
    public func getRegion() -> NetworkModels.SearchCriteriaItem? {
        return region
    }
}
