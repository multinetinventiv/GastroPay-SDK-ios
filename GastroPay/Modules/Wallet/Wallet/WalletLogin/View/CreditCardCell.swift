//
//  CreditCardCell.swift
//  Wallet
//
//  Created by  on 18.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

class CreditCardCell: UICollectionViewCell {

    let cardImageContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        $0.layer.cornerRadius = 25
    }

    let cardImage = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.cardSkewed
    }

    let cardInfoContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cardAlias = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.semiBoldTextFont(size: 17)
        $0.textColor = UIColor(red: 43/255, green: 46/255, blue: 53/255, alpha: 1.0)
    }

    let cardNumber = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.lightTextFont(size: 13)
        $0.textColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
    }

    let defaultCardInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.defaultCardLabel.local
        $0.font = FontHelper.lightTextFont(size: 13)
        $0.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1.0)
    }

    let tripleDots = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.tripleDot
        $0.isUserInteractionEnabled = true
    }

    var makeDefaultCardCallback: ((_ id: Int) -> Void)?
    var deleteCardCallback: ((_ id: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(cardImageContainer)
        cardImageContainer.addSubview(cardImage)
        contentView.addSubview(cardInfoContainer)
        cardInfoContainer.addSubview(cardAlias)
        cardInfoContainer.addSubview(cardNumber)
        cardInfoContainer.addSubview(defaultCardInfo)
        contentView.addSubview(tripleDots)

        tripleDots.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedTripleDots)))

        NSLayoutConstraint.activate([
            cardImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardImageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardImageContainer.widthAnchor.constraint(equalToConstant: 50),
            cardImageContainer.heightAnchor.constraint(equalToConstant: 50),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: cardImageContainer.heightAnchor, constant: 32).with({ (const) in
                const.priority = .init(999)
            }),

            cardImage.centerYAnchor.constraint(equalTo: cardImageContainer.centerYAnchor),
            cardImage.centerXAnchor.constraint(equalTo: cardImageContainer.centerXAnchor),
            cardImage.heightAnchor.constraint(equalToConstant: 25),
            cardImage.widthAnchor.constraint(equalToConstant: 30),

            cardInfoContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardInfoContainer.leadingAnchor.constraint(equalTo: cardImageContainer.trailingAnchor, constant: 16),
            cardInfoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: cardInfoContainer.heightAnchor, constant: 32).with({ (const) in
                const.priority = .init(999)
            }),

            cardAlias.topAnchor.constraint(equalTo: cardInfoContainer.topAnchor),
            cardAlias.leadingAnchor.constraint(equalTo: cardInfoContainer.leadingAnchor),
            cardAlias.trailingAnchor.constraint(equalTo: cardInfoContainer.trailingAnchor),

            cardNumber.topAnchor.constraint(equalTo: cardAlias.bottomAnchor),
            cardNumber.leadingAnchor.constraint(equalTo: cardInfoContainer.leadingAnchor),
            cardNumber.trailingAnchor.constraint(equalTo: cardInfoContainer.trailingAnchor),

            defaultCardInfo.topAnchor.constraint(equalTo: cardNumber.bottomAnchor),
            defaultCardInfo.bottomAnchor.constraint(equalTo: cardInfoContainer.bottomAnchor),
            defaultCardInfo.leadingAnchor.constraint(equalTo: cardInfoContainer.leadingAnchor),
            defaultCardInfo.trailingAnchor.constraint(equalTo: tripleDots.leadingAnchor),

            tripleDots.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tripleDots.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tripleDots.widthAnchor.constraint(equalToConstant: 25),
            tripleDots.heightAnchor.constraint(equalToConstant: 40),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: tripleDots.heightAnchor, constant: 32).with({ (const) in
                const.priority = .init(999)
            }),
        ])
    }

    @objc func tappedTripleDots(recognizer: UIGestureRecognizer) {
        if let target = recognizer.view {
            let alertController = UIAlertController(title: cardAlias.text, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: Localization.Wallet.cardMenuSetDefault.local, style: .default, handler: { (action) in
                self.makeDefaultCardCallback?(target.tag)
            }))
            alertController.addAction(UIAlertAction(title: Localization.Wallet.cardMenuDeleteCard.local, style: .destructive, handler: { (action) in
                self.deleteCardCallback?(target.tag)
            }))
            alertController.addAction(UIAlertAction(title: Localization.Wallet.cardMenuCancel.local, style: .cancel, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
        }
    }

    func configure(with card: CreditCard) {
        cardImageContainer.backgroundColor = card.isDefault! ? UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0) : UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0)
        cardAlias.text = card.alias
        cardNumber.text = card.number
        defaultCardInfo.isHidden = !card.isDefault!
        tripleDots.tag = card.id!
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
