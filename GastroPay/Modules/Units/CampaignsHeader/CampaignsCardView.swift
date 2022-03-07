//
//  CampaignsCardView.swift
//  Units
//
//  Created by  on 16.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

internal protocol CampaignsCardViewProtocol {
    func changedPage(to page: Int)
    func tappedRegister()
    func tappedLogin()
    func tappedCampaignDetail(campaign: Campaign)
    func campaignHeaderDidEndScrollDecelerating(scrollView: UIScrollView)
}

class CampaignsCardView: UIView {
    var collectionView: UICollectionView!
    var collectionViewLayout: UICollectionViewFlowLayout!

    var delegate: CampaignsCardViewProtocol?

    var campaigns: [Campaign]? {
        didSet {
            collectionView.removeFromSuperview()
            initCollectionView()
        }
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        initViews()
    }

    public func initViews() {
        initCollectionView()
    }

    private func initCollectionView() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionViewLayout.minimumInteritemSpacing = 32
        collectionViewLayout.minimumLineSpacing = 32

        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        collectionView.clipsToBounds = false

        collectionView.register(CampaignsHeaderCollectionAuthenticationCell.self)
        collectionView.register(CampaignsHeaderCollectionCampaignCell.self)
        collectionView.register(CampaignsHeaderCollectionPlaceholderCell.self)

        addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
    }

}

extension CampaignsCardView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let authenticationCellCount = Service.getAuthenticationManager()?.isUserAuthenticated() ?? false ? 0 : 1
        let campaignCellCount = self.campaigns?.count ?? 0
        let placeholderCellCount = Service.getAuthenticationManager()?.isUserAuthenticated() ?? false && self.campaigns?.count == 0 ? 1 : 0
        return authenticationCellCount + campaignCellCount + placeholderCellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0, !(Service.getAuthenticationManager()?.isUserAuthenticated() ?? false) {
            let cell = collectionView.dequeue(CampaignsHeaderCollectionAuthenticationCell.self, for: indexPath)
            cell.onTapRegister = {[weak self] in
                self?.delegate?.tappedRegister()
            }
            cell.onTapLogin = {[weak self] in
                self?.delegate?.tappedLogin()
            }
            return cell
        } else if (campaigns == nil || campaigns?.count == 0), indexPath.item == 0, (Service.getAuthenticationManager()?.isUserAuthenticated()) ?? false {
            return collectionView.dequeue(CampaignsHeaderCollectionPlaceholderCell.self, for: indexPath)
        } else {
            let cell = collectionView.dequeue(CampaignsHeaderCollectionCampaignCell.self, for: indexPath)
            if let campaign = campaigns?[safeIndex: indexPath.item - (Service.getAuthenticationManager()?.isUserAuthenticated() ?? false ? 0 : 1)] {
                cell.configure(withCampaign: campaign)
                cell.onTapCampaignDetail = {[weak self] in
                    self?.delegate?.tappedCampaignDetail(campaign: campaign)
                }
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: collectionView.bounds.height)
    }

}

extension CampaignsCardView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.campaignHeaderDidEndScrollDecelerating(scrollView: scrollView)
        delegate?.changedPage(to: Int((self.collectionView.contentOffset.x + self.collectionView.contentInset.left) / self.collectionView.frame.size.width))
    }

}
