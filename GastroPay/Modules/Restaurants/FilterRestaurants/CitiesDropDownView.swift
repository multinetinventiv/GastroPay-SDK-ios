***REMOVED***
***REMOVED***  CitiesDropDownView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import Foundation
import UIKit

class CitiesDropDownView: UIView {
    private let criteriaTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Search.criteriaTitle
        $0.textColor = ColorHelper.RestaurantSearch.criteriaTitle
        $0.text = Localization.Restaurants.searchRestaurantPickerAreaTitle.local
    }
    
    private let cityDropDown = DropDownView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = Localization.Restaurants.searchRestaurantPickerCityTitle.local
    }
    
    private let regionDropDown = DropDownView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = Localization.Restaurants.searchRestaurantPickerRegionTitle.local
    }
    
    var cityItems: [String] {
        set {
            cityDropDown.items = newValue
        }
        
        get {
            return cityDropDown.items
        }
    }
    
    var regionItems: [String] {
        set {
            regionDropDown.items = newValue
        }
        
        get {
            return regionDropDown.items
        }
    }
    
    var selectedCityIndex: Int {
        set {
            cityDropDown.selectedIndex = newValue
            
            onSelectedCityIndexChanged?(newValue)
        }
        
        get {
            return cityDropDown.selectedIndex
        }
    }
    
    var selectedRegionIndex: Int {
        set {
            regionDropDown.selectedIndex = newValue
        }
        
        get {
            return regionDropDown.selectedIndex
        }
    }

    var onSelectedCityIndexChanged: ((Int)->())?
    var onSelectedRegionIndexChanged: ((Int)->())?

    init() {
        super.init(frame: .zero)
        
        addSubview(criteriaTitleLabel)
        addSubview(cityDropDown)
        addSubview(regionDropDown)

        NSLayoutConstraint.activate([
            criteriaTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            criteriaTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            criteriaTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            criteriaTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            
            cityDropDown.topAnchor.constraint(equalTo: criteriaTitleLabel.bottomAnchor, constant: 16),
            cityDropDown.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cityDropDown.trailingAnchor.constraint(equalTo: regionDropDown.leadingAnchor, constant: -10),
            cityDropDown.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            regionDropDown.topAnchor.constraint(equalTo: criteriaTitleLabel.bottomAnchor, constant: 16),
            regionDropDown.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            regionDropDown.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            regionDropDown.widthAnchor.constraint(equalTo: cityDropDown.widthAnchor, multiplier: 1)
        ])
        
        cityDropDown.onSelectedIndexChanged = { index in
            self.selectedCityIndex = index
            
            self.onSelectedCityIndexChanged?(index)
        }
        
        regionDropDown.onSelectedIndexChanged = { index in
            self.selectedRegionIndex = index
            
            self.onSelectedRegionIndexChanged?(index)
        }
        
        setRegionDropdownUserInteractionEnabled(isEnabled: false)
    }
    
    func setRegionDropdownUserInteractionEnabled(isEnabled: Bool) {
        self.regionDropDown.setUserInteractionEnabled(isEnabled: isEnabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
