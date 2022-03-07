//
//  CampaignsHeaderCollectionAuthenticationCell.swift
//  Units
//
//  Created by  on 4.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

class CampaignsHeaderCollectionCampaignCell: UICollectionViewCell {
    var onTapCampaignDetail: (() -> Void)?

    var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorHelper.CampaignsHeader.cardBackgroundRegister
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
        label.textColor = .white
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    var campaignDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = FontHelper.regularTextFont(size: 13)
        label.minimumScaleFactor = 0.75
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Detay", for: .normal)
        button.backgroundColor = ColorHelper.Button.backgroundColor
        button.setTitleColor(ColorHelper.Button.textColor, for: .normal)
        button.titleLabel?.font = FontHelper.semiBoldTextFont(size: 18)
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        dropShadow()

        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(containerView)
        containerView.addSubview(campaignTitle)
        containerView.addSubview(campaignDescription)
        containerView.addSubview(actionButton)
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        actionButton.layer.cornerRadius = 16
        actionButton.addTarget(self, action: #selector(tappedIntoActionButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            containerView.topAnchor.constraint(equalTo: cardView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),

            campaignTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
            campaignTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            campaignTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            campaignTitle.heightAnchor.constraint(equalToConstant: 32),

            campaignDescription.topAnchor.constraint(equalTo: campaignTitle.bottomAnchor, constant: 8.0),
            campaignDescription.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16),
            campaignDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            campaignDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),

            actionButton.heightAnchor.constraint(equalToConstant: 32),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            actionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withCampaign campaign: Campaign) {
        campaignTitle.text = campaign.title ?? ""
        campaignDescription.text = campaign.description
    }

    @objc func tappedIntoActionButton() {
        self.onTapCampaignDetail?()
    }

}
