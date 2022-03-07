//
//  ManagedNetworkModel.swift
//  Shared
//
//  Created by  on 11.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import CoreLocation
import Foundation

public protocol RestaurantManagerDelegate: AnyObject {
    func restaurantManager(didUpdateRestaurants restaurants: [Merchant])
    func restaurantManagerRequestCancelled()
}

public class RestaurantManager {
    public var searchLocation: CLLocation?
    public var tags: [String]?
    public var query: String?
    public var selectedCity: SelectedCityModel?
    
    private var restaurants: [Merchant] = []
    
    public var page: Int = 0
    public var pagination: Int = 0
    public var isEndOfPagination: Bool = false
    
    private var pageLock: NSLock = NSLock()
    
    private var _delegates: [RestaurantManagerDelegate] = []
    
    private var _listeningLocationUpdates = false
    
    public init() {
        Service.getLocationManager()?.addDelegate(self)
        
        MIServiceBus.onMainThread(self, name: MIEventHelper.RestaurantFilterAction) { [weak self] notification in
            guard let self = self else { return }
            self.resetData()
            self.query = notification?.userInfo?["query"] as? String ?? nil
            self.tags = notification?.userInfo?["tags"] as? [String] ?? nil
            self.selectedCity = notification?.userInfo?["selectedCity"] as? SelectedCityModel ?? nil
            MIServiceBus.post(MIEventHelper.RefreshRestaurantLists)
            self.fetchNextRestaurants()
        }
    }
    
    public func unlockPageLock() {
        pageLock.unlock()
    }
    
    public func resetData() {
        self.pagination = 0
        isEndOfPagination = false
        self.page = 0
        self.query = nil
        self.tags = nil
        self.selectedCity = nil
        self.restaurants.removeAll()
    }
    
    public func getRestaurants() -> [Merchant] {
        return self.restaurants
    }
    
    public func startListeningLocationEvents() {
        self._listeningLocationUpdates = true
    }
    
    public func getOrInitRestaurants() -> [Merchant]? {
        if self.page == 0 {
            if let userLocation = Service.getLocationManager()?.lastLocation {
                self.searchLocation = userLocation
            } else {
                self._listeningLocationUpdates = true
                Service.getLocationManager()?.startListeningLocationEvents()
            }
            return nil
        } else {
            return self.restaurants
        }
    }
    
    public func fetchNextRestaurants(isForNextPage: Bool = false, isFromRestaurantVC: Bool = false) {
        guard let searchLocation = searchLocation else { return }
        
        if self.pageLock.try() {
            
            if isForNextPage, !isEndOfPagination{
                self.pagination += 1
            }
            
            else if isForNextPage, isEndOfPagination{
                for delegate in self._delegates {
                    delegate.restaurantManager(didUpdateRestaurants: self.restaurants)
                    delegate.restaurantManagerRequestCancelled()
                }
                
                Service.getLogger()?.debug("fetchNextRestaurants is cancelled due to isEndOfPagination is \(isEndOfPagination)")
                
                return
            }
            
            else{
                self.pagination = 0
                isEndOfPagination = false
            }
            
            let paginationValue = self.pagination
            
            var tags: [String]? = self.tags

            if let selectedRegionId = selectedCity?.getRegion()?.id {
                var selectedTags: Set<String> = Set(self.tags ?? [])
                selectedTags.insert(selectedRegionId)

                tags = Array(selectedTags)
            }
            
            Service.getAPI()?.getMerchantsInfo(latitude: searchLocation.coordinate.latitude , longitude: searchLocation.coordinate.longitude, isBonusPoint: nil, tags: tags, cityId: selectedCity?.city.id, merchantName_contains: self.query, paginationNumber: paginationValue, completion: { [weak self] result in

                guard let self = self else { return }
                
                defer{ self.pageLock.unlock() }
                
                switch result {
                case .success(let merchantResponse):
                    
                    var isAnyNewMerchant = false
                    
                    merchantResponse.merchants.forEach { (newMerchant) in
                        if !self.restaurants.contains(where: { (myMerch) -> Bool in
                            myMerch.merchantId == newMerchant.merchantId
                        })
                        {
                            isAnyNewMerchant = true
                            self.restaurants.append(newMerchant)
                        }
                    }
                    
                    if isForNextPage{
                        self.isEndOfPagination = merchantResponse.isLastPage
                        
                        if !isAnyNewMerchant || self.isEndOfPagination{
                            Service.getLogger()?.debug("RestaurantManager isEndOfPagination is true!!")
                        }
                    }
                    
                    self.page += 1
                    for delegate in self._delegates {
                        delegate.restaurantManager(didUpdateRestaurants: self.restaurants)
                    }
                    
                case .failure(let error):
                    for delegate in self._delegates {
                        delegate.restaurantManagerRequestCancelled()
                    }
                    Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                }
                
            })
            
            
        }
        else{
            Service.getLogger()?.debug("fetchNextRestaurants is cancelled due to lock")
        }
    }
    
    public func customSearch(location: CLLocation? = nil, query: String? = nil, isBonusPoint: Bool = false, tags: [String]? = nil, completion: @escaping (Result<MerchantResponse, Error>) -> Void) {
        guard let location = location ?? searchLocation else { return }
        
        Service.getAPI()?.getMerchantsInfo(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, isBonusPoint: isBonusPoint, tags: tags, merchantName_contains: query, paginationNumber: 0,  completion: completion)
    }
    
    public func addDelegate(_ delegate: RestaurantManagerDelegate) {
        self._delegates.append(delegate)
    }
    
    public func removeDelegate(_ delegate: RestaurantManagerDelegate) {
        if let index = _delegates.firstIndex(where: { $0 === delegate }) {
            self._delegates.remove(at: index)
        }
    }
}

extension RestaurantManager: LocationManagerDelegate {
    public var listeningLocationUpdates: Bool {
        return self._listeningLocationUpdates
    }
    
    public func locationManager(didUpdateLocation location: CLLocation) {
        self._listeningLocationUpdates = false
        self.searchLocation = location
        self.fetchNextRestaurants()
    }
}
