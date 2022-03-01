***REMOVED***
***REMOVED***  TagCollectionViewCellTemplate.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 13.02.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

class TagCollectionViewCellTemplate: UICollectionViewCell {
    let titleContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.RestaurantSearch.tagPillBackground
        $0.isSkeletonable = true
    }

    let title = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Search.tagTitle
        $0.textColor = ColorHelper.RestaurantSearch.criteriaItemTitle
        $0.text = "Placeholder"
        $0.textAlignment = .center
        $0.isSkeletonable = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white

        isSkeletonable = true
        contentView.clipsToBounds = false
        contentView.isSkeletonable = true

        contentView.addSubview(titleContainer)
        titleContainer.addSubview(title)

        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            title.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 8).with({ (const) in
                const.priority = .init(999)
            }),
            title.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: -8).with({ (const) in
                const.priority = .init(999)
            }),
            title.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 12).with({ (const) in
                const.priority = .init(999)
            }),
            title.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -12).with({ (const) in
                const.priority = .init(999)
            })
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(criteriaItem: NetworkModels.SearchCriteriaItem) {
        self.title.text = criteriaItem.tagName
        contentView.layoutIfNeeded()
        contentView.layer.applySketchShadow(color: UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131.0 / 255.0, alpha: 0.2), x: 2, y: 4, cornerRadius: 41)
        titleContainer.layer.cornerRadius = titleContainer.frame.height / 2
        titleContainer.backgroundColor = criteriaItem.selected ? ColorHelper.RestaurantSearch.tagPillBackgroundSelected : ColorHelper.RestaurantSearch.tagPillBackground
    }

}
