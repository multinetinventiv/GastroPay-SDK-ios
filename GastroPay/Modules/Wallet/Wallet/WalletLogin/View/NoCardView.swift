***REMOVED***
***REMOVED***  NoCardView.swift
***REMOVED***  Wallet
***REMOVED***
***REMOVED***  Created by  on 26.08.2020.
***REMOVED***  Copyright © 2020 Inventiv. All rights reserved.
***REMOVED***

import UIKit
import Then

class NoCardView: UIView {
    let artworkImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Wallet.noCardArtwork
        $0.contentMode = .scaleAspectFill
    }

    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.noCardTitle.local
        $0.font = FontHelper.Wallet.noCardTitle
        $0.textColor = ColorHelper.Wallet.noCardTitle
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    let descriptionLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.noCardDescription.local
        $0.font = FontHelper.Wallet.noCardDescription
        $0.textColor = ColorHelper.Wallet.noCardDescription
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    let addCardButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Wallet.noCardButtonTitle.local, for: .normal)
        $0.backgroundColor = ColorHelper.Button.backgroundColor
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.layer.cornerRadius = 25
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(artworkImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(addCardButton)

        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: topAnchor),
            artworkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            artworkImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor, multiplier: 340 / 375),

            titleLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            addCardButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            addCardButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 250 / 375),
            addCardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addCardButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
