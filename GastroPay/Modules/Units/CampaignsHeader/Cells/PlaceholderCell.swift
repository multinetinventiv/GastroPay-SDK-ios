***REMOVED***
***REMOVED***  PlaceholderCampaignCell.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 25.11.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit

class CampaignsHeaderCollectionPlaceholderCell: UICollectionViewCell {
    var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorHelper.CampaignsHeader.cardBackground
        return view
    }()

    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var campaignTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = Localization.Units.campaignsHeaderPlaceholderTitle.local
        label.textColor = UIColor(red: 0.153, green: 0.235, blue: 0.184, alpha: 1)
        label.font = FontHelper.regularTextFont(size: 18)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        dropShadow()

        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(containerView)
        containerView.addSubview(campaignTitle)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: cardView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),

            campaignTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            campaignTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            campaignTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            campaignTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
