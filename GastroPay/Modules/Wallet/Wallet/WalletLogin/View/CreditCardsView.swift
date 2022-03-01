***REMOVED***
***REMOVED***  CreditCardsView.swift
***REMOVED***  Wallet
***REMOVED***
***REMOVED***  Created by  on 18.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

class CreditCardsView: UIView {
    let headerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = Localization.Wallet.addedCards.local
        $0.font = FontHelper.Units.title
        $0.textColor = ColorHelper.Units.title
    }

    var collectionView: MIStackCollectionView

    var addCardCallback: (() -> Void)?
    var deleteCardCallback: ((_ cardId: Int) -> Void)?

    let addCardButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(Localization.Wallet.addCardButtonTitle.local, for: .normal)
        $0.backgroundColor = ColorHelper.Button.backgroundColor
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.addTarget(self, action: #selector(tappedAddCard), for: .touchUpInside)
    }

    private var cards: [CreditCard] = []

    override init(frame: CGRect) {
        collectionView = MIStackCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CreditCardCell.self)
        collectionView.backgroundColor = .clear

        collectionView.delegate = self
        collectionView.dataSource = self

        addSubview(headerLabel)
        addSubview(collectionView)
        addSubview(addCardButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            addCardButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            addCardButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addCardButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addCardButton.heightAnchor.constraint(equalToConstant: 50),
            addCardButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addCardButton.layer.cornerRadius = addCardButton.frame.height / 2
    }

    public func setCards(cards: [CreditCard]) {
        self.cards = cards
        collectionView.reloadData()
    }

    public func addCard(card: CreditCard) {
        self.cards.append(card)
        self.collectionView.reloadData()
    }

    @objc func tappedAddCard() {
        addCardCallback?()
    }

}

extension CreditCardsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CreditCardCell.self, for: indexPath)
        let creditCard = self.cards[indexPath.item]
        cell.configure(with: creditCard)
        cell.makeDefaultCardCallback = { id in
            Service.getTabbarController()?.view.setLoadingState(show: true)
            Service.getAPI()?.setDefaultStateForCard(id: id, defaultCardState: true) { (result) in
                defer { Service.getTabbarController()?.view.setLoadingState(show: false) }

                switch result {
                case .success(_):
                    for i in self.cards.indices {
                        if self.cards[i].id == id {
                            self.cards[i].isDefault = true
                        } else {
                            self.cards[i].isDefault = false
                        }
                    }
                    self.collectionView.reloadData()
                case .failure(let error):
                    Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                }
            }
        }
        cell.deleteCardCallback = deleteCardCallback
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeue(CreditCardCell.self, for: indexPath)
        let preferredSize = cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height))
        return CGSize(width: self.frame.width, height: preferredSize.height)
    }

}
