***REMOVED***
***REMOVED***  FilterRestaurantsViewModel.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Copyright © 2021 Multinet. All rights reserved.
***REMOVED***

import Foundation
import UIKit

class FilterRestaurantsViewModel {
    
    var restaurantManager: RestaurantManager? {
        let restaurantsNC = Service.getTabbarController()?.viewControllers?[1] as? MINavigationController
        _ = restaurantsNC?.topViewController as? RestaurantsVC
        return Service.getEarnableRestaurantsManager()
    }
    
    var query: String = ""
    var selectedTags: Set<String> = []
    
    var cities: [NetworkModels.City]?
    var regions: [NetworkModels.SearchCriteriaItem]?
    var selectedCity: SelectedCityModel? {
        get {
            if let restaurantsNC = Service.getTabbarController()?.viewControllers?[1] as? MINavigationController, let _ = restaurantsNC.topViewController as? RestaurantsVC {
                let restaurantManager =  Service.getEarnableRestaurantsManager()
                
                return restaurantManager?.selectedCity
            }
            
            return nil
        }
    }
    
    var cityNames: [String] {
        get {
            if let cities = self.cities {
                return getCityNames(cities: cities)
            } else {
                return []
            }
        }
    }
    
    var regionNames: [String] {
        get {
            if let regions = self.regions {
                return getRegionNames(regions: regions)
            } else {
                return []
            }
        }
    }
    
    var populatedSelectedRegion = false
    var citySearchCriteria = CitiesDropDownView()
    var categorySearchCriteria = SearchCriteriaView(cellType: .categories, spacingBetweenItems: 48)
    var tagSearchCriteria = SearchCriteriaView(cellType: .tags, spacingBetweenItems: 16)
    
    let filterButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Restaurants.filterButton.local, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.backgroundColor = ColorHelper.Button.backgroundColor
    }

    let clearFilterButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Restaurants.clearFilterButton.local, for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        $0.backgroundColor = ColorHelper.Button.backgroundColorDisabled
    }
    
    let searchController = UISearchController(searchResultsController: nil).then {
        $0.hidesNavigationBarDuringPresentation = false
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.setShowsCancelButton(false, animated: false)
        $0.searchBar.placeholder = Localization.Restaurants.searchBarPlaceholderText.local
    }

    init(viewController: FilterRestaurantsVC) {
        self.citySearchCriteria.onSelectedCityIndexChanged = { [weak self] index in
            guard let self = self else { return }
            
            self.citySearchCriteria.regionItems = []
            self.citySearchCriteria.setRegionDropdownUserInteractionEnabled(isEnabled: false)

            if index != 0 {
                self.regions = nil

                self.getCriterias(viewController)
            }
        }
    }
    
    func getCriterias(_ viewController: FilterRestaurantsVC) {
        var cityId: Int? = nil
        if self.citySearchCriteria.selectedCityIndex > 0 {
            cityId = self.cities?[safeIndex:self.citySearchCriteria.selectedCityIndex-1]?.id
        }
        
        viewController.view.setLoadingState(show: true)

        Service.getAPI()?.getSearchCriterias(cityId: cityId) {[weak self] (result) in
            guard let self = self else { return }
            
            defer { viewController.view.setLoadingState(show: false)}

            switch result {
            case .success(let criterias):
                if viewController.presentingViewController != nil {
                    for criteria in criterias {
                        if self.citySearchCriteria.selectedCityIndex > 0 && criteria.tagGroupKey == SearchCriteriaViewType.cities.rawValue {
                            if criteria.tags.count > 0 {
                                self.citySearchCriteria.setRegionDropdownUserInteractionEnabled(isEnabled: true)
                                self.citySearchCriteria.regionItems = self.regionNames
                                
                                self.regions = criteria.tags
                                
                                self.citySearchCriteria.regionItems = self.regionNames

                                if !self.populatedSelectedRegion,
                                   let selectedRegion = self.selectedCity?.getRegion(),
                                   let regions = self.regions,
                                   let index = regions.firstIndex(where: { region in region.id == selectedRegion.id }) {
                                    
                                    self.citySearchCriteria.selectedRegionIndex = index+1
                                    
                                    self.populatedSelectedRegion = true
                                }
                            }
                        }

                        if criteria.tagGroupKey == SearchCriteriaViewType.categories.rawValue {
                            self.categorySearchCriteria.setCriteriaData(criteriaData: criteria)
                        }

                        if criteria.tagGroupKey == SearchCriteriaViewType.tags.rawValue {
                            self.tagSearchCriteria.setCriteriaData(criteriaData: criteria)
                        }
                    }
                    
                    self.initStackView(stackView: viewController.stackView, view: viewController.view)
                 }
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }

            viewController.stackView.hideSkeleton()
        }
    }
    
    func getCities(viewController: FilterRestaurantsVC) {
        Service.getAPI()?.getCities { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cities):
                self.cities = cities.cities
                
                self.citySearchCriteria.cityItems = self.cityNames

                if let selectedCity = self.selectedCity,
                   let cities = self.cities,
                   let index = cities.firstIndex(where: { city in
                    city.id == selectedCity.getCity().id
                }) {
                    self.citySearchCriteria.selectedCityIndex = index+1
                } else {
                    self.getCriterias(viewController)
                }
                
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                break
            }
        }
    }
    
    func getCityNames(cities: [NetworkModels.City]) -> [String] {
        var items = [String]()
        
        cities.forEach { item in
            items.append(item.name)
        }
        
        return items
    }
    
    func getRegionNames(regions: [NetworkModels.SearchCriteriaItem]) -> [String] {
        var items = [String]()
        
        regions.forEach { item in
            items.append(item.tagName)
        }
        
        return items
    }
}

extension FilterRestaurantsViewModel{
    
    func viewDidLayout(){
        filterButton.layer.cornerRadius = filterButton.frame.height / 2
        clearFilterButton.layer.cornerRadius = clearFilterButton.frame.height / 2
    }
    
    func initStackView(stackView: MIStackView, view: UIView) {
        stackView.addRow(citySearchCriteria)
        stackView.setInset(forRow: citySearchCriteria, inset: .zero)
        
        if categorySearchCriteria.criteriaData != nil {
            stackView.addRow(categorySearchCriteria)
            stackView.setInset(forRow: categorySearchCriteria, inset: .zero)
        } else {
            if categorySearchCriteria.superview != nil {
                categorySearchCriteria.removeFromSuperview()
            }
        }
        
        if tagSearchCriteria.criteriaData != nil {
            stackView.addRow(tagSearchCriteria)
            stackView.setInset(forRow: tagSearchCriteria, inset: .zero)
        } else {
            if tagSearchCriteria.superview != nil {
                tagSearchCriteria.removeFromSuperview()
            }
        }

        stackView.addRow(filterButton)
        stackView.setRowSkeletonable(row: filterButton, isSkeletonable: false)
        stackView.setInset(forRow: filterButton, inset: UIEdgeInsets(top: 32, left: 16, bottom: 8, right: 16))
        stackView.addRow(clearFilterButton)
        stackView.setRowSkeletonable(row: clearFilterButton, isSkeletonable: false)
        stackView.setInset(forRow: clearFilterButton, inset: UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))

        view.layoutIfNeeded()
        stackView.showAnimatedGradientSkeleton()
    }
    
}
