//
//  MerchantListCollectionViewCell.swift
//  Units
//
//  Created by  on 15.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

class MerchantListCollectionViewCell: UICollectionViewCell {
    let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.General.woman
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let listTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.MerchantLists.title
        label.textColor = ColorHelper.Units.MerchantLists.listTitle
        label.numberOfLines = 0
        return label
    }()

    let placeCountIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageHelper.General.listsPlaceCountIcon
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    let merchantCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.MerchantLists.merchantCount
        label.textColor = ColorHelper.Units.MerchantLists.merchantCount
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImage)
        backgroundImage.bindFrameToSuperviewBounds()

        merchantCount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(merchantCount)
        merchantCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
        merchantCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
        merchantCount.heightAnchor.constraint(greaterThanOrEqualToConstant: 22.0).isActive = true
        merchantCount.widthAnchor.constraint(greaterThanOrEqualToConstant: 20.0).isActive = true

        contentView.addSubview(placeCountIcon)
        placeCountIcon.trailingAnchor.constraint(equalTo: merchantCount.trailingAnchor).isActive = true
        placeCountIcon.bottomAnchor.constraint(equalTo: merchantCount.topAnchor, constant: -8.0).isActive = true
        placeCountIcon.heightAnchor.constraint(equalTo: placeCountIcon.widthAnchor).isActive = true
        placeCountIcon.widthAnchor.constraint(equalToConstant: 25.0).isActive = true

        listTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentView.addSubview(listTitle)
        listTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        listTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
        listTitle.trailingAnchor.constraint(equalTo: merchantCount.leadingAnchor, constant: 0.0).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: MerchantList) {
        backgroundImage.setImage(from: model.imageUrl, placeholder: ImageHelper.General.woman, animation: .fade)
        listTitle.text = model.tagName
        merchantCount.text = Localization.Units.merchantListsCountLabel.local.replacingOccurrences(of: "%1$s", with: "\(model.merchantCount)")
    }
}
