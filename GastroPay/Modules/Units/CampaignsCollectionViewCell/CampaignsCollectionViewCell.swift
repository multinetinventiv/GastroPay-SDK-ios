***REMOVED***
***REMOVED***  CampaignCollectionViewCell.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 10.11.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public class CampaignsCollectionViewCell: UICollectionViewCell {
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.General.woman
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let campaignTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Campaigns.campaignTitle
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    let remainingTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Campaigns.campaignRemainingTime
        label.textColor = ColorHelper.Campaigns.campaignRemainingTime
        return label
    }()

    let timeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ImageHelper.Icons.time
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(backgroundImage)
        backgroundImage.bindFrameToSuperviewBounds()

        initLabels()
        initYeTLImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initYeTLImageView() {
        addSubview(timeIcon)

        timeIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        timeIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timeIcon.bottomAnchor.constraint(equalTo: remainingTime.topAnchor, constant: 7).isActive = true
        timeIcon.trailingAnchor.constraint(equalTo: remainingTime.trailingAnchor, constant: 10).isActive = true
    }

    func initLabels() {
        addSubview(remainingTime)
        addSubview(campaignTitle)

        remainingTime.leadingAnchor.constraint(equalTo: campaignTitle.trailingAnchor, constant: 16.0).isActive = true
        remainingTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        remainingTime.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0).isActive = true
        remainingTime.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        remainingTime.widthAnchor.constraint(greaterThanOrEqualToConstant: 30.0).isActive = true

        campaignTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0).isActive = true
        campaignTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        campaignTitle.trailingAnchor.constraint(equalTo: remainingTime.leadingAnchor, constant: -16.0).isActive = true
    }

    public func configure(with campaign: Campaign) {
        backgroundImage.setImage(from: campaign.imageUrl, placeholder: nil, animation: .fade)
        campaignTitle.text = campaign.title

        let dateDifference = Calendar.current.dateComponents([.day], from: Date(), to: campaign.endTime)

        if dateDifference.day ?? 0 < 30 {
            remainingTime.text = Date().toRemainingTimeText(campaign.endTime)
        } else {
            timeIcon.isHidden = true
            remainingTime.isHidden = true
        }
    }

}
