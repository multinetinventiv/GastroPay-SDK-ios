***REMOVED***
***REMOVED***  RestaurantDetailHeaderView.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 22.09.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

class RestaurantDetailHeaderView: UIView {
    let backgroundImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    let puanIconImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.puanYellow
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    private let puanStateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = FontHelper.Restaurants.Detail.earn
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .blue

        addSubview(backgroundImageView)
        backgroundImageView.addSubview(puanIconImageView)
        backgroundImageView.addSubview(puanStateLabel)

        let referenceHeight: CGFloat = 358 / 375 * UIScreen.main.bounds.width

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: referenceHeight).with({ (const) in
                const.priority = .init(249)
            }),
            backgroundImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: referenceHeight),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            puanIconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 40),
            puanIconImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            puanIconImageView.heightAnchor.constraint(equalToConstant: 110),
            puanIconImageView.widthAnchor.constraint(equalToConstant: 110),

            puanStateLabel.topAnchor.constraint(equalTo: puanIconImageView.bottomAnchor, constant: 15),
            puanStateLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initMerchant(_ merchant: Merchant) {
        self.backgroundImageView.setImage(from: merchant.showcaseImageUrl)
        
        if let issBonusPoint = merchant.isBonusPoint {
            puanIconImageView.isHidden = false

            if issBonusPoint {
                puanStateLabel.text = Localization.Restaurants.Detail.earn.local
            } else {
                puanStateLabel.text = Localization.Restaurants.Detail.spend.local
            }
        }
    }
}
