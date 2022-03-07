//
//  DefaultPopupDialogView.swift
//  Shared
//
//  Created by  on 25.12.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import AMXFontAutoScale
import Then
import UIKit

public class AddCardPopupView: UIView, MIPopupView {
    public var dialogId: String

    public var actionCallback: (() -> Void)?

    let artwork = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.PopupArtworks.addCard
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
    }

    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.title
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PopupDialog.titleText
        $0.amx_autoScaleFont(forReferenceScreenSize: .size4p7Inch)
        $0.numberOfLines = 0
    }

    let bodyLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.body
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PopupDialog.bodyText
        $0.amx_autoScaleFont(forReferenceScreenSize: .size4p7Inch)
        $0.numberOfLines = 0
    }

    let actionButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("KARTINI EKLE", for: .normal)
        $0.backgroundColor = ColorHelper.Button.backgroundColor
        $0.setTitleColor(ColorHelper.PopupDialog.actionButtonText, for: .normal)
        $0.titleLabel?.font = FontHelper.PopupDialog.actionButton
    }

    let closeButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(ImageHelper.Icons.close, for: .normal)
        $0.imageView?.tintColor = .black
    }

    init(dialogId: String) {
        self.dialogId = dialogId
        super.init(frame: .zero)

        backgroundColor = .white

        closeButton.addTarget(self, action: #selector(onTapCloseButton), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(onTapActionButton), for: .touchUpInside)

        addSubview(artwork)
        addSubview(closeButton)
        addSubview(actionButton)
        addSubview(bodyLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20),

            artwork.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            artwork.trailingAnchor.constraint(equalTo: trailingAnchor),
            artwork.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 75 / 100),
            artwork.heightAnchor.constraint(equalTo: artwork.widthAnchor, multiplier: 453 / 300).with { constraint in
                constraint.priority = .init(rawValue: 1000)
            },

            titleLabel.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: -32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            actionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        actionButton.layer.cornerRadius = actionButton.frame.height / 2
    }

    @objc private func onTapActionButton() {
        Service.getPopupManager()?.hideDialog(self)
        actionCallback?()
    }

    @objc func onTapCloseButton() {
        Service.getPopupManager()?.hideDialog(self)
    }
}
