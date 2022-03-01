***REMOVED***
***REMOVED***  CampaignsHeaderWithLoadingState.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 14.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then

public enum ShowcaseCampaignsHeaderNavType {
    case icon
    case title
}

public class ShowcaseCampaignsHeaderView: UIView {
    private struct Constants {
        @available(iOS 11.0, *)
        static let gastroLogoTopMargin: CGFloat = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0 + 16
        static let gastroLogoTopMarginiOS10: CGFloat = 16

        static let gastroLogoAspectRatio: CGFloat = 86.0 / 58.0
        static let gastroLogoSuperviewWidthRatio: CGFloat = 86.0 / 375.0

        static let pagerHeight: CGFloat = 10.0
        static let pagerTrailingMargin: CGFloat = 16.0
        static let pagerLeadingMargin: CGFloat = 16.0
        static let pagerTopMargin: CGFloat = 16.0


        static let headerHeight: CGFloat = min(350 / 667 * (UIApplication.shared.keyWindow?.rootViewController?.view.frame.height ?? 1), 420) + 15
    }

    public var onTapRegister: (() -> Void)?
    public var onTapLogin: (() -> Void)?
    public var onTapCampaignDetail: ((_ campaign: Campaign) -> Void)?
    public var onScrollViewDidEndDecelerating: ((_ scrollView: UIScrollView) -> Void)?

    public var campaigns: [Campaign]? {
        didSet {
            refreshCampaigns()
        }
    }

    public var showOnlyRegister = true

    public var navbarType: ShowcaseCampaignsHeaderNavType = .icon {
        didSet {
            switch self.navbarType {
            case .icon:
                break
            case .title:
                self.gastroIcon.isHidden = true
                break
            }
        }
    }

    var gastroIconTopConstraint: NSLayoutConstraint!
    let gastroIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ImageHelper.Home.gastroPayLogo
        return imageView
    }()

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = ImageHelper.General.woman
        imageView.clipsToBounds = true
        return imageView
    }()

    let cardView: CampaignsCardView = {
        let cardView = CampaignsCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()

    let pager: UIPageControl = {
        let pager = UIPageControl()
        pager.translatesAutoresizingMaskIntoConstraints = false

        pager.currentPageIndicatorTintColor = ColorHelper.Pager.activePageIndicator
        pager.pageIndicatorTintColor = ColorHelper.Pager.indicator

        return pager
    }()

    public init(navbarType: ShowcaseCampaignsHeaderNavType = .icon, onlyRegister: Bool = false) {
        self.navbarType = navbarType
        self.showOnlyRegister = onlyRegister
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        if self.showOnlyRegister {
            self.campaigns = []
        }
        initViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func initViews() {
        initBackgroundImage()
        if navbarType == .icon {
            initLogo()
        }
        initCardView()
        if !showOnlyRegister {
            initPager()
        }
    }

    private func initLogo() {
        addSubview(gastroIcon)
        gastroIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gastroIcon.widthAnchor.constraint(equalTo: gastroIcon.heightAnchor, multiplier: Constants.gastroLogoAspectRatio).isActive = true
        gastroIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.gastroLogoSuperviewWidthRatio).isActive = true
        if #available(iOS 11.0, *) {
            gastroIcon.topAnchor.constraint(equalTo: topAnchor, constant: Constants.gastroLogoTopMargin).isActive = true
        } else {
            gastroIcon.topAnchor.constraint(equalTo: topAnchor, constant: Constants.gastroLogoTopMarginiOS10).isActive = true
        }
    }

    private func initBackgroundImage() {
        addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        let referenceHeight: CGFloat = min(350 / 667 * UIScreen.main.bounds.height, 420) * 250 / 350
        backgroundImageView.heightAnchor.constraint(equalToConstant: referenceHeight).with({ (const) in
            const.priority = .init(249)
        }).isActive = true
        backgroundImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: referenceHeight).isActive = true
    }

    private func initCardView() {
        addSubview(cardView)
        cardView.delegate = self
        cardView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -15).isActive = true
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        let referenceHeight: CGFloat = min(350 / 667 * UIScreen.main.bounds.height, 420) * 175 / 350
        cardView.heightAnchor.constraint(equalToConstant: referenceHeight).isActive = true
        if showOnlyRegister {
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }

    private func initPager() {
        addSubview(pager)
        pager.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.pagerLeadingMargin).isActive = true
        pager.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.pagerTrailingMargin).isActive = true
        pager.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 10).isActive = true
        pager.heightAnchor.constraint(equalToConstant: Constants.pagerHeight).isActive = true
        pager.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }

    public func refreshCampaigns() {
        let authenticationCellCount = Service.getAuthenticationManager()?.isUserAuthenticated() ?? false ? 0 : 1
        let campaignCellCount = self.campaigns?.count ?? 0
        let placeholderCellCount = Service.getAuthenticationManager()?.isUserAuthenticated() ?? false && self.campaigns?.count == 0 ? 1 : 0
        pager.numberOfPages = authenticationCellCount + campaignCellCount + placeholderCellCount
        cardView.campaigns = self.campaigns
        cardView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        changedPage(to: 0)
    }

}

extension ShowcaseCampaignsHeaderView: CampaignsCardViewProtocol {
    
    func campaignHeaderDidEndScrollDecelerating(scrollView: UIScrollView) {
        onScrollViewDidEndDecelerating?(scrollView)
    }

    func changedPage(to page: Int) {
        self.pager.currentPage = page

        if page == 0 && !(Service.getAuthenticationManager()?.isUserAuthenticated() ?? false) {
            backgroundImageView.setImage(image: ImageHelper.General.woman, animation: .fade)
            return
        }

        if let campaign = self.campaigns?[safeIndex:(page - (Service.getAuthenticationManager()?.isUserAuthenticated() ?? false ? 0 : 1))] {
            backgroundImageView.setImage(from: campaign.imageUrl, placeholder: ImageHelper.General.woman, animation: .fade, delayPlaceholder: true)
        } else {
            backgroundImageView.setImage(image: ImageHelper.General.woman, animation: .fade)
        }
    }

    func tappedRegister() {
        self.onTapRegister?()
    }
    
    func tappedLogin() {
        self.onTapLogin?()
    }

    func tappedCampaignDetail(campaign: Campaign) {
        self.onTapCampaignDetail?(campaign)
    }

}
