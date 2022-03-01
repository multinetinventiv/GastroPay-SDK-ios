***REMOVED***
***REMOVED***  PaymentSelectCard.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***  Created by Hasan Hüseyin Gücüyener on 25.05.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then
import AMXFontAutoScale

class PaymentSelectCard: UIView {
    var cards: [CreditCard]?
    var selectedCardId: Int = 0

    let cellHeightMultiplier: CGFloat = 94 / 375
    let cellWidthMultiplier: CGFloat = 320 / 375

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .gray
        $0.layer.zPosition = CGFloat(Int.max)
    }

    let containerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.PaymentConfirmation.SelectCard.containerBackgroundColor
    }

    let selectCardLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Payment.InfoScreen.selectCard.local
        $0.font = FontHelper.PaymentConfirmation.SelectCard.selectCardLabel
        $0.textColor = ColorHelper.PaymentConfirmation.SelectCard.selectCardLabel
    }

    lazy var cardsCollectionView: UICollectionView = {
        let screenWidth = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ?? 0
        let cellWidth = round(screenWidth * cellWidthMultiplier)
        let collectionViewFlowLayout = MICollectionViewHorizontalFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 16
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.isPagingEnabled = true
        collectionViewFlowLayout.cellWidth = cellWidth
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.register(PaymentCardCell.self)
        return collectionView
    }()

    var onSelectCard: ((_ card: CreditCard) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addSubview(containerView)
        containerView.addSubview(selectCardLabel)
        containerView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            selectCardLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            selectCardLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            selectCardLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),

            activityIndicator.topAnchor.constraint(equalTo: selectCardLabel.bottomAnchor, constant: 16),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
        ])
        
        activityIndicator.startAnimating()

        containerView.layer.applySketchShadow(
            color: ColorHelper.PaymentConfirmation.SelectCard.containerShadowColor,
            alpha: 1, x: 0, y: -2, blur: 8, cornerRadius: 0
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCards(cards: [CreditCard]) {
        self.cards = cards

        for card in cards {
            if card.isDefault! {
                self.selectedCardId = card.id!
            }
        }
        
        activityIndicator.removeFromSuperview()

        containerView.addSubview(cardsCollectionView)

        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self

        let screenWidth = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ?? 0
        let collectionHeight = screenWidth * cellHeightMultiplier

        NSLayoutConstraint.activate([
            cardsCollectionView.topAnchor.constraint(equalTo: selectCardLabel.bottomAnchor, constant: 16),
            cardsCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardsCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cardsCollectionView.heightAnchor.constraint(equalToConstant: collectionHeight).with({ (const) in
                const.priority = .init(999)
            }),
            cardsCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])

        cardsCollectionView.layoutIfNeeded()

        cards.enumerated().forEach({[weak self] (elem) in
            guard let self = self else { return }

            if(elem.element.isDefault == true) {
                self.cardsCollectionView.scrollToItem(at: IndexPath(item: elem.offset, section: 0), at: .centeredHorizontally, animated: true)
            }
        })
    }

}

extension PaymentSelectCard: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PaymentCardCell.self, for: indexPath)
        if let card = cards?[indexPath.item] {
            cell.configure(with: card)

            if selectedCardId > 0 {
                cell.setSelected(state: selectedCardId == card.id)
            } else if card.isDefault == true {
                cell.setSelected(state: true)
            } else {
                cell.setSelected(state: false)
            }
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIApplication.shared.keyWindow?.rootViewController?.view.bounds.width ?? 0
        let cellWidth = round(screenWidth * cellWidthMultiplier)
        let cellHeight = round(cellWidth * cellHeightMultiplier)

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let card = cards?[indexPath.item] {
            selectedCardId = card.id!
            cardsCollectionView.reloadData()
            onSelectCard?(card)
        }
    }

}

class PaymentCardCell: UICollectionViewCell {
    let bankImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let cardInfoContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cardAlias = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.SelectCard.cardAlias
        $0.textColor = ColorHelper.PaymentConfirmation.SelectCard.cardAliasText
        $0.amx_autoScaleEnabled = true
        $0.amx_referenceScreenSize = .size4p7Inch
    }

    let cardMaskedNumber = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.PaymentConfirmation.SelectCard.cardMaskedNumber
        $0.amx_autoScaleEnabled = true
        $0.amx_referenceScreenSize = .size4p7Inch
        $0.textColor = ColorHelper.PaymentConfirmation.SelectCard.cardMaskedNumber
    }

    let paymentBrand = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }

    let selectedCardLabelContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = ColorHelper.PaymentConfirmation.SelectCard.selectedCardLabelContainerBackground
    }

    let selectedCardLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.99
        $0.attributedText = NSMutableAttributedString(string: Localization.Payment.InfoScreen.selectedCard.local, attributes: [NSAttributedString.Key.kern: 0.07, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        $0.font = FontHelper.PaymentConfirmation.SelectCard.selectedCardLabel
        $0.amx_autoScaleEnabled = true
        $0.amx_referenceScreenSize = .size5p5Inch
        $0.textColor = ColorHelper.PaymentConfirmation.SelectCard.selectedCardLabelText
    }

    let tickIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.tickWithoutBorder
        $0.contentMode = .scaleAspectFill
        $0.tintColor = UIColor(rgb: 0x395945)
    }

    private lazy var gradient: CALayer = {
        return CAGradientLayer().then { (layer) in
            layer.colors = [
                ColorHelper.PaymentConfirmation.SelectCard.cellSelectedGradientStop0.cgColor,
                ColorHelper.PaymentConfirmation.SelectCard.cellSelectedGradientStop1.cgColor
            ]
            layer.frame = contentView.frame
            layer.locations = nil
        }
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = ColorHelper.PaymentConfirmation.SelectCard.cellBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        contentView.addSubview(bankImage)
        contentView.addSubview(cardInfoContainer)
        cardInfoContainer.addSubview(cardAlias)
        cardInfoContainer.addSubview(cardMaskedNumber)
        contentView.addSubview(paymentBrand)
        contentView.addSubview(selectedCardLabelContainer)
        selectedCardLabelContainer.addSubview(selectedCardLabel)
        selectedCardLabelContainer.addSubview(tickIcon)

        NSLayoutConstraint.activate([
            bankImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bankImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bankImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            bankImage.widthAnchor.constraint(equalToConstant: 50),

            cardInfoContainer.leadingAnchor.constraint(equalTo: bankImage.trailingAnchor, constant: 12),
            cardInfoContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            cardAlias.leadingAnchor.constraint(equalTo: cardInfoContainer.leadingAnchor),
            cardAlias.trailingAnchor.constraint(equalTo: cardInfoContainer.trailingAnchor),
            cardAlias.topAnchor.constraint(equalTo: cardInfoContainer.topAnchor),

            cardMaskedNumber.topAnchor.constraint(equalTo: cardAlias.bottomAnchor, constant: 4),
            cardMaskedNumber.leadingAnchor.constraint(equalTo: cardInfoContainer.leadingAnchor),
            cardMaskedNumber.trailingAnchor.constraint(equalTo: cardInfoContainer.trailingAnchor),
            cardMaskedNumber.bottomAnchor.constraint(equalTo: cardInfoContainer.bottomAnchor),

            paymentBrand.leadingAnchor.constraint(equalTo: cardInfoContainer.trailingAnchor, constant: 8),
            paymentBrand.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            paymentBrand.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            paymentBrand.widthAnchor.constraint(equalToConstant: 30),
            paymentBrand.heightAnchor.constraint(equalToConstant: 30),

            selectedCardLabelContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            selectedCardLabelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            selectedCardLabel.leadingAnchor.constraint(equalTo: selectedCardLabelContainer.leadingAnchor, constant: 8),
            selectedCardLabel.topAnchor.constraint(equalTo: selectedCardLabelContainer.topAnchor, constant: 5),
            selectedCardLabel.bottomAnchor.constraint(equalTo: selectedCardLabelContainer.bottomAnchor, constant: -5),

            tickIcon.leadingAnchor.constraint(equalTo: selectedCardLabel.trailingAnchor, constant: 8),
            tickIcon.topAnchor.constraint(equalTo: selectedCardLabelContainer.topAnchor, constant: 5),
            tickIcon.bottomAnchor.constraint(equalTo: selectedCardLabelContainer.bottomAnchor, constant: -5),
            tickIcon.trailingAnchor.constraint(equalTo: selectedCardLabelContainer.trailingAnchor, constant: -8),
            tickIcon.widthAnchor.constraint(equalToConstant: 16),
            tickIcon.heightAnchor.constraint(equalToConstant: 12)

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        selectedCardLabelContainer.layoutIfNeeded()
        selectedCardLabelContainer.layer.cornerRadius = selectedCardLabelContainer.frame.height / 2
    }

    func configure(with card: CreditCard) {
        if let bankLogoUrl = card.bankLogoUrl {
            paymentBrand.isHidden = false
            bankImage.setImage(from: bankLogoUrl)
        } else {
            bankImage.isHidden = true
        }

        cardAlias.text = card.alias

        if let cardNumber = card.number {
            let formattedCardNumber = cardNumber.enumerated().map({ String($0.element) + ($0.offset % 4 == 3 ? "  " : "") }).joined()
            cardMaskedNumber.text = formattedCardNumber
        }

        if let paymentBrandImageUrl = card.paymentBrandLogoUrl {
            paymentBrand.isHidden = false
            paymentBrand.setImage(from: paymentBrandImageUrl)
        } else {
            paymentBrand.isHidden = true
        }
    }

    func setSelected(state: Bool) {
        selectedCardLabelContainer.isHidden = !state

        if state {
            addSelectedLayer()
        } else {
            removeSelectedLayer()
        }

        setNeedsLayout()
        setNeedsDisplay()
        layoutIfNeeded()
    }

    private func addSelectedLayer() {
        contentView.layer.insertSublayer(gradient, at: 0)
    }

    private func removeSelectedLayer() {
        gradient.removeFromSuperlayer()
    }

}
