***REMOVED***
***REMOVED***  FilterRestaurantsVC.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 12.02.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import YPNavigationBarTransition
import SkeletonView

protocol FilterRestaurantsDelegate: AnyObject {
    func filterRestaurants(query: String, tags: String)
    func removeFilters()
}

public class FilterRestaurantsVC: MIStackableViewController, UISearchControllerDelegate {
    weak var delegate: FilterRestaurantsDelegate?
    
    var viewModel: FilterRestaurantsViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FilterRestaurantsViewModel(viewController: self)
        
        view.backgroundColor = .white
        
        viewModel.query = viewModel.restaurantManager?.query ?? ""
        viewModel.selectedTags = Set<String>(viewModel.restaurantManager?.tags ?? [])
        
        viewModel.searchController.searchResultsUpdater = self
        viewModel.searchController.searchBar.delegate = self
        
        viewModel.categorySearchCriteria.delegate = self
        viewModel.tagSearchCriteria.delegate = self
        
        viewModel.getCities(viewController: self)
        
        viewModel.filterButton.addTarget(self, action: #selector(onTapFilter), for: .touchUpInside)
        viewModel.clearFilterButton.addTarget(self, action: #selector(onTapClearFilters), for: .touchUpInside)
        
        navigationItem.titleView = viewModel.searchController.searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: ImageHelper.Icons.close.tinted(with: .black), style: .done, target: self, action: #selector(tappedClose)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        if let restaurantsNC = Service.getTabbarController()?.viewControllers?[1] as? MINavigationController, let _ = restaurantsNC.topViewController as? RestaurantsVC {
            let restaurantManager = Service.getEarnableRestaurantsManager()
            self.viewModel.searchController.searchBar.text = restaurantManager?.query
        }
        
        animateWithKeyboard {[weak self] (keyboardHeight) in
            DispatchQueue.main.async {
                let insetForKeyboard = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
                self?.stackView.contentInset = insetForKeyboard
                self?.stackView.scrollIndicatorInsets = insetForKeyboard
            }
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.searchController.searchBar.becomeFirstResponder()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.restaurantManager?.resetData()
        
        viewModel.searchController.isActive = false
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayout()
    }
}

extension FilterRestaurantsVC {
    
    @objc func tappedClose() {
        self.dismiss(animated: true)
    }
    
    @objc func onTapFilter() {        
        if let restaurantsNC = Service.getTabbarController()?.viewControllers?[safeIndex:1] as? MINavigationController, let restaurantsVC = restaurantsNC.topViewController as? RestaurantsVC {
            restaurantsVC.redirectionType = .others
        }
        
        var userInfo: [String : Any] = [
            "query": viewModel.query,
            "tags": Array(viewModel.selectedTags)]
        
        if self.viewModel.citySearchCriteria.selectedCityIndex > 0, let city =  self.viewModel.cities?[safeIndex:self.viewModel.citySearchCriteria.selectedCityIndex-1] {
            userInfo["selectedCity"] = SelectedCityModel(city: city, region: (self.viewModel.regions?[safeIndex:self.viewModel.citySearchCriteria.selectedRegionIndex-1]) ?? nil)
        } else {
            userInfo["selectedCity"] = nil
        }
        
        MIServiceBus.post(MIEventHelper.RestaurantFilterAction, userInfo: userInfo)
        viewModel.searchController.isActive = false
        self.dismiss(animated: true)
    }
    
    @objc func onTapClearFilters() {
        if let restaurantsNC = Service.getTabbarController()?.viewControllers?[1] as? MINavigationController, let restaurantsVC = restaurantsNC.topViewController as? RestaurantsVC {
            restaurantsVC.redirectionType = .others
        }
        
        MIServiceBus.post(MIEventHelper.RestaurantFilterAction, userInfo: [
            "query": "",
            "tags": [],
            "selectedCity": ""
        ])
        viewModel.searchController.isActive = false
        self.dismiss(animated: true)
    }
    
}

extension FilterRestaurantsVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel.query = searchController.searchBar.text ?? ""
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        onTapFilter()
    }
}

extension FilterRestaurantsVC: SearchCriteriaViewDelegate {
    
    func onAddTag(tag: String) {
        viewModel.selectedTags.insert(tag)
    }
    
    func onRemoveTag(tag: String) {
        viewModel.selectedTags.remove(tag)
    }
}

extension FilterRestaurantsVC: NavigationBarConfigureStyle{
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return .white
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
