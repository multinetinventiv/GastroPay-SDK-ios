***REMOVED***
***REMOVED***  YemedenOlmazDetailHeaderView.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by Emrah Korkmaz on 7.02.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit

class YemedenOlmazDetailHeaderView: UICollectionReusableView {

    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.RestaurantDetail.mealBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let restaurantIconImage: UIImageView = {
        var iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = ImageHelper.RestaurantDetail.starbucksTemplate
        iv.clipsToBounds = true
        return iv
    }()
    
    let restaurantTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Starbucks".uppercased()
        label.textColor = .white
        label.font = FontHelper.Restaurants.Detail.earn
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImage)
        backgroundImage.addSubview(restaurantIconImage)
        backgroundImage.addSubview(restaurantTitle)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            restaurantIconImage.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            restaurantIconImage.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 50),
            restaurantIconImage.heightAnchor.constraint(equalToConstant: 50),
            restaurantIconImage.widthAnchor.constraint(equalToConstant: 50),
            
            restaurantTitle.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            restaurantTitle.topAnchor.constraint(equalTo: restaurantIconImage.bottomAnchor, constant: 11)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

