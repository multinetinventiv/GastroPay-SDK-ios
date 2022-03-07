//
//  MerchantLists.swift
//  Units
//
//  Created by  on 15.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

public class MerchantLists: UIView {
    public struct Constants {
        static let collectionViewAspectRatio: CGFloat = 184.0 / 300.0

        static let titleLabelHeight: CGFloat = 22.0
        static let titleLabelLeadingMargin: CGFloat = 16.0
        static let titleLabelTrailingMargin: CGFloat = 16.0
        static let titleLabelBottomMargin: CGFloat = 16.0
    }

    public private(set) var merchantLists: [MerchantList] = []

    public var onTouchMerchantList: ((_ merchantList: MerchantList) -> Void)?

    let unitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.Units.merchantListsTitle.local
        label.textColor = ColorHelper.Units.title
        label.font = FontHelper.Units.title
        return label
    }()

    let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        collectionView.register(MerchantListCollectionViewCell.self)
        return collectionView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initTitleLabel()
        initCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadWith(merchantLists: [MerchantList]) {
        self.merchantLists = merchantLists
        self.collectionView.reloadData()
    }

    func initTitleLabel() {
        addSubview(unitTitleLabel)

        unitTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeadingMargin).isActive = true
        unitTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleLabelTrailingMargin).isActive = true
        unitTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        unitTitleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
    }

    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: unitTitleLabel.bottomAnchor, constant: Constants.titleLabelBottomMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        let itemWidth = UIScreen.main.bounds.width * 300.0 / 375.0
        collectionView.heightAnchor.constraint(equalToConstant: itemWidth * Constants.collectionViewAspectRatio).isActive = true
    }
}

extension MerchantLists: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchantLists.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MerchantListCollectionViewCell.self, for: indexPath)
        cell.configure(with: merchantLists[indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 300.0 / 375.0
        let height = width * Constants.collectionViewAspectRatio
        return CGSize(width: Int(width), height: Int(height))
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onTouchMerchantList?(merchantLists[indexPath.item])
    }

}
