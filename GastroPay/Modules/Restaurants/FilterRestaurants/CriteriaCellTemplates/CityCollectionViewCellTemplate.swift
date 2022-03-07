//
//  CityCollectionCellTemplate.swift
//  Restaurants
//
//  Created by  on 13.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class CityCollectionViewCellTemplate: UICollectionViewCell {

    let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let titleView = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Search.criteriaItemTitle
        $0.textColor = ColorHelper.RestaurantSearch.criteriaItemTitle
        $0.text = "Text For Skeleton"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white

        isSkeletonable = true
        contentView.clipsToBounds = false
        contentView.isSkeletonable = true

        contentView.addSubview(imageView)
        contentView.addSubview(titleView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).with({ (const) in
                const.priority = .init(999)
            }),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).with({ (const) in
                const.priority = .init(999)
            }),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16).with({ (const) in
                const.priority = .init(999)
            }),
            imageView.widthAnchor.constraint(equalToConstant: 15).with({ (const) in
                const.priority = .init(999)
            }),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 21 / 15),

            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).with({ (const) in
                const.priority = .init(999)
            }),
            titleView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).with({ (const) in
                const.priority = .init(999)
            }),
            titleView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16).with({ (const) in
                const.priority = .init(999)
            }),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(criteriaItem: NetworkModels.SearchCriteriaItem) {
        self.titleView.text = criteriaItem.tagName
        if let imageUrl = criteriaItem.icon?.url {
            self.imageView.setImage(from: imageUrl)
        }
        contentView.backgroundColor = criteriaItem.selected ? ColorHelper.RestaurantSearch.tagPillBackgroundSelected : ColorHelper.RestaurantSearch.tagPillBackground
    }

    func configure(title: String, imageUrl: String) {
        self.titleView.text = title
        self.imageView.setImage(from: imageUrl)
    }

}
