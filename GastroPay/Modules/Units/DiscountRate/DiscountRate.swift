***REMOVED***
***REMOVED***  DiscountRate.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 30.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit

public class DiscountView: UIView {
    public let discountOval: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.General.merchantSavingBackground
        return iv
    }()

    public let percent: UILabel = {
        let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.textAlignment = .center
        iv.minimumScaleFactor = 0.5
        iv.font = FontHelper.discountLabel
        return iv
    }()

    public let yetl: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.Icons.puanText
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    public init(withYetl: Bool = true) {
        super.init(frame: .zero)
        initViews(showYetl: withYetl)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initViews(showYetl: Bool = true) {
        addSubview(discountOval)
        discountOval.addSubview(percent)
        if showYetl {
            addSubview(yetl)
        }

        NSLayoutConstraint.activate([
            discountOval.topAnchor.constraint(equalTo: topAnchor),
            discountOval.leadingAnchor.constraint(equalTo: leadingAnchor),
            discountOval.trailingAnchor.constraint(equalTo: trailingAnchor),
            discountOval.heightAnchor.constraint(equalTo: discountOval.widthAnchor, multiplier: 56 / 60),

            percent.centerXAnchor.constraint(equalTo: discountOval.centerXAnchor),
            percent.centerYAnchor.constraint(equalTo: discountOval.centerYAnchor),
            percent.widthAnchor.constraint(lessThanOrEqualTo: discountOval.widthAnchor, multiplier: 40 / 60),
        ])

        if showYetl {
            NSLayoutConstraint.activate([
                yetl.topAnchor.constraint(equalTo: discountOval.bottomAnchor, constant: 8),
                yetl.leadingAnchor.constraint(equalTo: discountOval.leadingAnchor),
                yetl.trailingAnchor.constraint(equalTo: discountOval.trailingAnchor),
                yetl.heightAnchor.constraint(equalTo: yetl.widthAnchor, multiplier: 23 / 49),
                yetl.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                discountOval.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    public func setRewardRate(_ rate: String) {
        let discountRateString = NSMutableAttributedString(string: rate)
        discountRateString.addAttributes([
            NSAttributedString.Key.font: FontHelper.DiscountView.percentSign,
            NSAttributedString.Key.foregroundColor: ColorHelper.Restaurants.MapView.rewardString
        ], range: NSRange(location: 0, length: 1))
        discountRateString.addAttributes([
            NSAttributedString.Key.font: FontHelper.DiscountView.percentLabel,
            NSAttributedString.Key.foregroundColor: ColorHelper.Restaurants.MapView.rewardString
        ], range: NSRange(location: 1, length: rate.count - 1))
        percent.attributedText = discountRateString
    }

    public func setPercent(percent: String) {
        /*let discountRateString = NSMutableAttributedString(
            string: "%",
            attributes: [
                NSAttributedString.Key.font: FontHelper.DiscountView.percentSign
            ]
        )

        discountRateString.append(
            NSAttributedString(
                string: percent,
                attributes: [
                    NSAttributedString.Key.font: FontHelper.DiscountView.percentLabel
                ]
            )
        )

        self.percent.attributedText = discountRateString*/
        self.percent.text = percent
    }

}
