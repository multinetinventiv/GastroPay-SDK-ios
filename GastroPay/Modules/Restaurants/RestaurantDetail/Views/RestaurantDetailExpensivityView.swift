***REMOVED***
***REMOVED***  RestaurantDetailExpensivityView.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 25.09.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

class RestaurantDetailExpensivityView: UIView {
    var expensivity: Int?

    let headerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Restaurants.Detail.expensivity.local
        $0.font = FontHelper.regularTextFont(size: 17)
        $0.textColor = ColorHelper.activeColor.withAlphaComponent(0.54)
    }

    let expensivityCollectionView = MIStackCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        ($0.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        ($0.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = UICollectionViewFlowLayout.automaticSize
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        $0.register(RestaurantDetailExpensivityCell.self)
        $0.backgroundColor = .none
    }

    init() {
        super.init(frame: .zero)

        expensivityCollectionView.delegate = self
        expensivityCollectionView.dataSource = self

        addSubview(headerLabel)
        addSubview(expensivityCollectionView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            expensivityCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            expensivityCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            expensivityCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            expensivityCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            expensivityCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RestaurantDetailExpensivityView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RestaurantDetailExpensivityCell.self, for: indexPath)
        if indexPath.item + 1 - (self.expensivity ?? 0) > 0 {
            cell.imageView.image = ImageHelper.RestaurantDetail.expensivityDisabled
        } else {
            cell.imageView.image = ImageHelper.RestaurantDetail.expensivityEnabled
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

}

class RestaurantDetailExpensivityCell: UICollectionViewCell {
    var imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
