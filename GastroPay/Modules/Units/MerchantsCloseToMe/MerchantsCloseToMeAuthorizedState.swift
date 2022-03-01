***REMOVED***
***REMOVED***  MerchantsCloseToMeAuthorizedState.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 17.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

class MerchantsCloseToMeAuthorizedState: UIView {
    var delegate: MerchantsCloseToMeProtocol?

    public var merchants: [Merchant]? {
        didSet {
            collectionView.reloadData()
        }
    }

    public var showUnitTitle: Bool = true

    let unitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.Units.merchantsCloseTitle.local
        label.font = FontHelper.Units.title
        label.textColor = ColorHelper.Units.title
        return label
    }()

    let collectionView: MIDynamicHeightCollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = MIDynamicHeightCollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        collectionView.register(MerchantsCloseToMeCollectionViewCell.self)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initTitleLabel()
        initCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initTitleLabel() {
        addSubview(unitTitleLabel)

        unitTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        unitTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        unitTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        unitTitleLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
    }

    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.heightAnchor.constraint(equalToConstant: 241).isActive = true
        addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: unitTitleLabel.bottomAnchor, constant: 16.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

}

extension MerchantsCloseToMeAuthorizedState: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchants?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MerchantsCloseToMeCollectionViewCell.self, for: indexPath)
        cell.configure(for: merchants![indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 241.0
        let width = height * 231.0 / 194.0
        return CGSize(width: Int(width), height: Int(height))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.tappedRestaurant(restaurant: merchants![indexPath.item])
    }

}
