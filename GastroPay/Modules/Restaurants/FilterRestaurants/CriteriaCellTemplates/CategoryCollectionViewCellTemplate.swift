//
//  CategoryCollectionViewCellTemplate.swift
//  Restaurants
//
//  Created by  on 13.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class CategoryCollectionViewCellTemplate: UICollectionViewCell {
    let imageContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }

    let image = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    let title = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Search.criteriaItemTitle
        $0.textColor = ColorHelper.RestaurantSearch.criteriaItemTitle
        $0.text = "Placeholder"
        $0.textAlignment = .center
        $0.minimumScaleFactor = 0.5
        $0.autoScale = true
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white

        isSkeletonable = true
        contentView.clipsToBounds = false
        contentView.isSkeletonable = true

        contentView.addSubview(imageContainer)
        imageContainer.addSubview(image)
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).with({ (const) in
                const.priority = .init(999)
            }),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).with({ (const) in
                const.priority = .init(999)
            }),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).with({ (const) in
                const.priority = .init(999)
            }),
            imageContainer.heightAnchor.constraint(equalToConstant: 82),

            image.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 16),
            image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -16),
            image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -16),

            title.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).with({ (const) in
                const.priority = .init(999)
            }),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).with({ (const) in
                const.priority = .init(999)
            }),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).with({ (const) in
                const.priority = .init(999)
            })
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(criteriaItem: NetworkModels.SearchCriteriaItem) {
        contentView.layoutIfNeeded()
        imageContainer.layer.applySketchShadow(color: UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131.0 / 255.0, alpha: 0.2), x: 2, y: 4, cornerRadius: 41)

        self.title.text = criteriaItem.tagName
        if let imageUrl = criteriaItem.icon?.url {
            self.image.setImage(from: imageUrl)
        }
        imageContainer.backgroundColor = criteriaItem.selected ? ColorHelper.RestaurantSearch.tagPillBackgroundSelected : ColorHelper.RestaurantSearch.tagPillBackground
    }

}
