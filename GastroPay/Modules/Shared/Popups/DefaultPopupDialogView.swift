***REMOVED***
***REMOVED***  DefaultPopupDialogView.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Then
import UIKit

public class DefaultPopupDialogView: UIView, MIPopupView {
    public var dialogId: String

    public var actionCallback: (() -> Void)?

    public var willHideCallback: (() -> Void)?

    let artwork = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.PopupArtworks.addCard
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.title
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PopupDialog.titleText
        $0.numberOfLines = 0
    }

    let bodyLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PopupDialog.body
        $0.textAlignment = .center
        $0.textColor = ColorHelper.PopupDialog.bodyText
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

    init(dialogId: String, title: String? = nil) {
        self.dialogId = dialogId
        if let titleText = title {
            titleLabel.text = titleText
        }
        super.init(frame: .zero)

        backgroundColor = .white

        closeButton.addTarget(self, action: #selector(onTapCloseButton), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(onTapActionButton), for: .touchUpInside)

        addSubview(artwork)
        addSubview(closeButton)
        addSubview(actionButton)
        addSubview(bodyLabel)

        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

        artwork.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        artwork.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        artwork.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        if let title = titleLabel.text, !title.isEmpty {
            addSubview(titleLabel)
            titleLabel.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 16).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        } else {
            bodyLabel.topAnchor.constraint(equalTo: artwork.bottomAnchor, constant: 16).isActive = true
        }

        bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

        actionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16).isActive = true
        actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        actionButton.layer.cornerRadius = actionButton.frame.height / 2
    }

    @objc func onTapCloseButton() {
        Service.getPopupManager()?.hideDialog(self)
        actionCallback?()
    }

    @objc func onTapActionButton() {
        Service.getPopupManager()?.hideDialog(self)
        actionCallback?()
    }

    public func popupWillBeHidden() {
        willHideCallback?()
    }
}
