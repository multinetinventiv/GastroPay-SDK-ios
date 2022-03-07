//
//  CreditCardCampaignCollectionViewCell.swift
//  Units
//
//  Created by  on 21.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

class CreditCardCampaignCollectionViewCellBase: UICollectionViewCell {
    let campaignImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let campaignDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.CreditCardCampaigns.title
        label.textColor = ColorHelper.Units.CreditCardCampaigns.title
        label.numberOfLines = 3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
        contentView.backgroundColor = .white

        campaignDescription.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.addSubview(campaignDescription)

        campaignDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0).isActive = true
        campaignDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
        campaignDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true

        campaignImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentView.addSubview(campaignImageView)
        campaignImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        campaignImageView.bottomAnchor.constraint(equalTo: campaignDescription.topAnchor, constant: -8.0).isActive = true
        campaignImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        campaignImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with model: Campaign) {
        campaignImageView.setImage(from: model.imageUrl)
        campaignDescription.text = model.title
    }

}

class CreditCardCampaignCollectionViewCell: CreditCardCampaignCollectionViewCellBase {

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.75
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
