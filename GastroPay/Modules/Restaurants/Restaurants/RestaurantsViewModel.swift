//
//  RestaurantsViewModel.swift
//  Gastropay
//
//  Created on 14.06.2021.
//

import Foundation

public class RestaurantsViewModel {
    let closeLabelText = Localization.Restaurants.labelNear.local
    let closeLabelFont = FontHelper.Restaurants.headerLabelClose
    let searchButtonImage = ImageHelper.Icons.search_green
    
    var restaurantView: RestaurantView
    var restaurantManager: RestaurantManager?
    
    public init(onTappedSearch: (() -> ())? = nil, onTappedClose: (() -> ())? = nil,
                onTappedSettings: (() -> ())? = nil, onSelectMerchant: ((Merchant?) -> Void)? = nil, onSetLoadingIndicator: @escaping ((Bool) -> ())) {
        restaurantManager = Service.getSpendableRestaurantsManager() ?? nil
        restaurantView = RestaurantView(restaurantManager: restaurantManager)
        
        restaurantView.onTappedSearch = onTappedSearch
        restaurantView.onTappedClose = onTappedClose
        restaurantView.onTappedSettings = onTappedSettings
        restaurantView.onSelectMerchant = onSelectMerchant
        restaurantView.onSetLoadingIndicator = onSetLoadingIndicator
        
        configureHeaderView()
    }
    
    func setLoadingState(show: Bool) {
        restaurantView.restaurantList?.setLoadingState(show: show)
    }
    
    func fetchNextRestaurants() {
        restaurantManager?.fetchNextRestaurants(isFromRestaurantVC: true)
    }
    
    func configureHeaderView() {
        restaurantView.closeLabel.text = closeLabelText
        restaurantView.closeLabel.font = closeLabelFont
        restaurantView.searchIcon.image = searchButtonImage
    }
}
