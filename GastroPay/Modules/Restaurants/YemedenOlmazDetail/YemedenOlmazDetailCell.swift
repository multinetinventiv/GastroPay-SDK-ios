//
//  YemedenOlmazDetailCell.swift
//  Restaurants
//
//  Created by Emrah Korkmaz on 7.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

public class YemedenOlmazDetailCell: UICollectionViewCell{

    let containerTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.Restaurants.Detail.yemedenOlmaz.local
        label.font = FontHelper.Restaurants.Detail.mealContainerTitle
        label.numberOfLines = 0
        return label
    }()

    let mealTitle: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.font = FontHelper.Restaurants.Detail.mealTitle
        label.numberOfLines = 0
        return label
    }()

    let mealDescription: UITextView = {
        var label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Restaurants.Detail.mealDescription
        return label
    }()

    public func setDetail(mealTitle: String, mealDescription: String){
        self.mealTitle.text = mealTitle
        self.mealDescription.text = mealDescription
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(containerTitle)
        addSubview(mealTitle)
        addSubview(mealDescription)

        containerTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 27).isActive = true
        containerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        containerTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true

        mealTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 27).isActive = true
        mealTitle.topAnchor.constraint(equalTo: containerTitle.bottomAnchor, constant: 12).isActive = true
        mealTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true

        mealDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 27).isActive = true
        mealDescription.topAnchor.constraint(equalTo: mealTitle.bottomAnchor, constant: 27).isActive = true
        mealDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        mealDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
