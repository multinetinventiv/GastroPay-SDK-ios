***REMOVED***
***REMOVED***  MerchantsCloseToMeCollectionViewCell.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 17.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public class MerchantsCloseToMeCollectionViewCell: UICollectionViewCell {
    private var backgroundGradient: CALayer?

    public let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private var backgroundImageGradient: CAGradientLayer?

    public let merchantTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.MerchantsClose.merchantTitle
        label.textColor = ColorHelper.Units.MerchantsClose.title
        return label
    }()
    public var constTitleTrailingToDiscountLeading: NSLayoutConstraint!
    public var constTitleTrailingToCellTrailing: NSLayoutConstraint!

    public let merchantDistance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.MerchantsClose.merchantDistance
        label.textColor = ColorHelper.Units.MerchantsClose.distance
        return label
    }()
    public var constDistanceTrailingToDiscountLeading: NSLayoutConstraint!
    public var constDistanceTrailingToCellTrailing: NSLayoutConstraint!

    public let discountRate: DiscountView = {
        let discountView = DiscountView(withYetl: false)
        discountView.translatesAutoresizingMaskIntoConstraints = false
        discountView.yetl.isHidden = true
        return discountView
    }()

    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        if backgroundImageGradient == nil {
            backgroundImageGradient = CoreAnimationsHelper.GradientLayer.createBottomToTopGradientLayer()
            backgroundImage.backgroundColor = UIColor.clear
            backgroundImageGradient!.frame = layoutAttributes.bounds
            backgroundImage.layer.insertSublayer(backgroundImageGradient!, at: 0)
            contentView.dropShadow()
        }
        return layoutAttributes
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImage)
        backgroundImage.bindFrameToSuperviewBounds()
        clipsToBounds = false
        contentView.clipsToBounds = false

        addSubview(merchantDistance)
        addSubview(merchantTitle)
        initTitleLabel()
        initDistanceLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initDiscountRate() {
        addSubview(discountRate)

        discountRate.heightAnchor.constraint(equalToConstant: 56).isActive = true
        discountRate.widthAnchor.constraint(equalToConstant: 60).isActive = true
        discountRate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        discountRate.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }

    func initTitleLabel() {
        merchantTitle.bottomAnchor.constraint(equalTo: merchantDistance.topAnchor, constant: -2.0).isActive = true
        merchantTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        merchantTitle.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        constTitleTrailingToDiscountLeading = merchantTitle.trailingAnchor.constraint(equalTo: discountRate.leadingAnchor, constant: -8.0)
        constTitleTrailingToCellTrailing = merchantTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
    }

    func initDistanceLabel() {
        merchantDistance.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0).isActive = true
        merchantDistance.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0).isActive = true
        merchantDistance.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        constDistanceTrailingToCellTrailing = merchantDistance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
        constDistanceTrailingToDiscountLeading = merchantDistance.trailingAnchor.constraint(equalTo: discountRate.leadingAnchor, constant: -8.0)
    }

    public func configure(for merchant: Merchant, hideDiscountRate: Bool = false) {
        merchantTitle.text = merchant.name
        merchantDistance.text = merchant.getDistanceAsMeters()
        backgroundImage.setImage(from: merchant.showcaseImageUrl, placeholder: ImageHelper.General.woman, animation: .fade)

        if let discountPercent = merchant.rewardPercentage, merchant.isBonusPoint ?? false, !hideDiscountRate {
            setDiscountRateVisibility(true)
            discountRate.setRewardRate(discountPercent)
        } else {
            setDiscountRateVisibility(false)
        }

        self.layoutIfNeeded()
    }

    public func setDiscountRateVisibility(_ visible: Bool) {
        if visible {
            initDiscountRate()

            constDistanceTrailingToDiscountLeading.isActive = true
            constDistanceTrailingToCellTrailing.isActive = false

            constTitleTrailingToDiscountLeading.isActive = true
            constTitleTrailingToCellTrailing.isActive = false
        } else {
            constDistanceTrailingToDiscountLeading.isActive = false
            constDistanceTrailingToCellTrailing.isActive = true

            constTitleTrailingToDiscountLeading.isActive = false
            constTitleTrailingToCellTrailing.isActive = true

            discountRate.removeFromSuperview()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        if backgroundGradient == nil {
            backgroundGradient = CoreAnimationsHelper.GradientLayer.createBottomToTopGradientLayer()
            backgroundGradient!.frame = backgroundImage.bounds
            backgroundImage.layer.insertSublayer(backgroundGradient!, at: 0)
        }
    }
}
