//
//  MerchantsCloseToMeUnauthorizedState.swift
//  Units
//
//  Created by  on 17.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

public class MerchantsCloseToMeUnauthorizedState: UIView {
    let titleView: UIView = {
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()

    let unitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontHelper.Units.title
        label.textColor = ColorHelper.Units.title
        label.text = Localization.Units.merchantsCloseTitle.local
        return label
    }()

    let locationView: UIView = {
        let locationView = UIView()
        locationView.translatesAutoresizingMaskIntoConstraints = false
        return locationView
    }()

    public var showTitle: Bool

    public init(showTitle: Bool = true) {
        self.showTitle = showTitle

        super.init(frame: .zero)

        if showTitle {
            initTitleView()
        }
        initLocationInfoView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initTitleView() {
        addSubview(titleView)
        
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        titleView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        titleView.addSubview(unitTitleLabel)
        unitTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        unitTitleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        unitTitleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        unitTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
    }

    func initLocationInfoView() {
        addSubview(locationView)

        if showTitle {
            locationView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16).isActive = true
        } else {
            locationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        locationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        locationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        locationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = ImageHelper.General.requestLocationIcon
        icon.contentMode = .scaleAspectFit
        locationView.addSubview(icon)

        icon.leadingAnchor.constraint(equalTo: locationView.leadingAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: locationView.topAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 65).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 95).isActive = true

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Localization.LocationPermissionWarning.title.local
        titleLabel.font = FontHelper.Units.MerchantsClose.locationPermissionTitle
        titleLabel.textColor = ColorHelper.LocationPermissionWarning.title
        locationView.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: locationView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: locationView.trailingAnchor).isActive = true

        let locationDesc = UILabel()
        locationDesc.translatesAutoresizingMaskIntoConstraints = false
        locationDesc.text = Localization.LocationPermissionWarning.description.local
        locationDesc.font = FontHelper.Units.MerchantsClose.locationPermissionDescription
        locationDesc.textColor = ColorHelper.LocationPermissionWarning.description
        locationDesc.numberOfLines = 0

        locationView.addSubview(locationDesc)

        locationDesc.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        locationDesc.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16.0).isActive = true
        locationDesc.trailingAnchor.constraint(equalTo: locationView.trailingAnchor).isActive = true
        locationDesc.bottomAnchor.constraint(equalTo: locationView.bottomAnchor).isActive = true
    }

}
