***REMOVED***
***REMOVED***  RestaurantDetailVC.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 22.09.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import SwiftyMarkdown
import Bartinter
import Then
import YPNavigationBarTransition
import Lightbox

public class RestaurantDetailVC: MIStackableViewControllerWithHeader {
    var viewModel: RestaurantDetailViewModel!

    override public var headerView: UIView {
        get {
            return viewModel.restaurantDetailHeaderView.with { (header) in
                header.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        set { }
    }

    let titleLabel = UILabel().then {
        $0.textColor = .clear
        $0.font = FontHelper.Navigation.title
    }

    var navigationBarGradientProgress: CGFloat = 0 {
        didSet {
            statusBarUpdater?.refreshStatusBarStyle()
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarUpdater?.preferredStatusBarStyle ?? .lightContent
    }

    public init(_ merchant: Merchant) {
        viewModel = RestaurantDetailViewModel(merchant: merchant)

        super.init()

        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self

        titleLabel.text = merchant.name
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageHelper.Icons.backArrow, style: .done, target: self, action: #selector(tappedBack))
        
        viewModel.onSetLoadingState = { show in
            self.setLoadingState(show: show)
        }
                
        viewModel.restaurantDetailHeaderView.initMerchant(merchant)
        viewModel.getMerchantDetail(viewController: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        statusBarUpdater = Bartinter(Bartinter.Configuration(initialStatusBarStyle: .lightContent))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        yp_refreshNavigationBarStyle()
    }

    @objc func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension RestaurantDetailVC: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.y + scrollView.contentInset.top
        var gradientProgress: CGFloat
        
        if #available(iOS 11.0, *) {
            gradientProgress = max(0.0, min(1.0, progress / (viewModel.restaurantDetailHeaderView.frame.height - view.safeAreaInsets.top)))
        } else {
            gradientProgress = max(0.0, min(1.0, progress / (viewModel.restaurantDetailHeaderView.frame.height)))
        }
        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress
        
        if self.navigationBarGradientProgress != gradientProgress {
            self.navigationBarGradientProgress = gradientProgress
            yp_refreshNavigationBarStyle()
        }
    }
}

extension RestaurantDetailVC: NavigationBarConfigureStyle {
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        var configuration: YPNavigationBarConfigurations = .backgroundStyleColor

        if navigationBarGradientProgress == 1 {
            configuration = .backgroundStyleOpaque
        }

        titleLabel.textColor = UIColor(white: 1.0 - navigationBarGradientProgress, alpha: navigationBarGradientProgress)

        return configuration
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return UIColor(white: 1.0 - navigationBarGradientProgress, alpha: 1.0)
    }

    public func yp_navigationBackgroundColor() -> UIColor! {
        return UIColor(white: 1.0, alpha: navigationBarGradientProgress)
    }
    
}
