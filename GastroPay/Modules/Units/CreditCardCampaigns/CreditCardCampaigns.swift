//
//  CreditCardCampaigns.swift
//  Units
//
//  Created by  on 17.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit
import SkeletonView

public class CreditCardCampaigns: UIView {
    private struct Constants {
        static let collectionViewContentInset = UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
        static let collectionViewItemSpacing: CGFloat = 32.0
        static let collectionViewSuperviewWidthRatio: CGFloat = 194.0 / 375.0

        static let titleLabelHeight: CGFloat = 22.0
        static let titleLabelTrailingSpacing: CGFloat = 16.0
        static let titleLabelLeadingSpacing: CGFloat = 16.0
        static let titleLabelBottomMargin: CGFloat = 16.0

        static let pagerHeight: CGFloat = 10.0
        static let pagerBottomMargin: CGFloat = 16.0
        static let pagerTopMargin: CGFloat = 16.0
        static let pagerTrailingMargin: CGFloat = 16.0
        static let pagerLeadingMargin: CGFloat = 16.0
    }

    public private(set) var campaigns: [Campaign] = []

    public var onSelectCampaign: ((_ campaign: Campaign) -> Void)?

    let unitTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.Units.creditCardCampaignsTitle.local
        label.font = FontHelper.Units.title
        label.textColor = ColorHelper.Units.title
        label.isSkeletonable = true
        return label
    }()

    let collectionView: MIDynamicHeightCollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = Constants.collectionViewItemSpacing
        collectionViewFlowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = MIDynamicHeightCollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isPagingEnabled = true
        collectionView.register(CreditCardCampaignCollectionViewCellBase.self)
        collectionView.register(CreditCardCampaignCollectionViewCell.self)
        collectionView.isSkeletonable = true
        return collectionView
    }()

    let pager: UIPageControl = {
        let pager = UIPageControl()
        pager.translatesAutoresizingMaskIntoConstraints = false

        pager.currentPageIndicatorTintColor = ColorHelper.Pager.activePageIndicator
        pager.pageIndicatorTintColor = ColorHelper.Pager.indicator
        pager.isSkeletonable = true

        return pager
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSkeletonable = true
        translatesAutoresizingMaskIntoConstraints = false
        initTitleLabel()
        initPager()
        initCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initTitleLabel() {
        addSubview(unitTitleLabel)
        unitTitleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        unitTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleLabelLeadingSpacing).isActive = true
        unitTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.titleLabelTrailingSpacing).isActive = true
        unitTitleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
    }

    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: unitTitleLabel.bottomAnchor, constant: Constants.titleLabelBottomMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: pager.topAnchor, constant: -Constants.pagerTopMargin).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 215 / 350).isActive = true
    }

    func initPager() {
        addSubview(pager)
        pager.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.pagerLeadingMargin).isActive = true
        pager.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.pagerTrailingMargin).isActive = true
        pager.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.pagerBottomMargin).isActive = true
        pager.heightAnchor.constraint(equalToConstant: Constants.pagerHeight).isActive = true
    }

    public func reloadWith(creditCardCampaigns campaigns: [Campaign]) {
        self.campaigns = campaigns
        self.pager.numberOfPages = campaigns.count
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    public func isCampaignsEmpty() -> Bool {
        return campaigns.isEmpty
    }

}

extension CreditCardCampaigns: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(CreditCardCampaignCollectionViewCell.self, for: indexPath)
        cell.configure(with: campaigns[indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.width * 215 / 350)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectCampaign?(campaigns[indexPath.item])
    }

}

extension CreditCardCampaigns: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {

    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: CreditCardCampaignCollectionViewCellBase.self)
    }

}

extension CreditCardCampaigns: UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int((self.collectionView.contentOffset.x + self.collectionView.contentInset.left) / self.collectionView.frame.size.width)
        pager.currentPage = page
    }

}
