//
//  NavigationButtonView.swift
//  Restaurants
//
//  Created by  on 25.09.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class NavigationButtonView: UIView {
    let navigationButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(ColorHelper.Login.loginButtonText, for: .normal)
        $0.setTitle(Localization.Restaurants.Detail.navigation.local, for: UIControl.State.normal)
        $0.titleLabel?.font = FontHelper.Container.navigationButton
        $0.backgroundColor = ColorHelper.Login.loginButtonBackground
        $0.addTarget(self, action: #selector(tappedNavigateButton), for: .touchUpInside)
    }

    var onTapNavigate: (() -> Void)?

    init() {
        super.init(frame: .zero)
        addSubview(navigationButton)

        NSLayoutConstraint.activate([
            navigationButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 40),
            navigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            navigationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            navigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            navigationButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tappedNavigateButton() {
        onTapNavigate?()
    }
}
