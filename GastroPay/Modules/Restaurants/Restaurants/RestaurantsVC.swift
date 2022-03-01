***REMOVED***
***REMOVED***  RestaurantsVC.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 25.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit
import YPNavigationBarTransition

public enum RestaurantRedirectionType {
    case none
    case home
    case others
}

public class RestaurantsVC: MIViewController {
    var viewModel: RestaurantsViewModel!
    var isScrollViewSetup = false
    var redirectionType: RestaurantRedirectionType = .none

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = RestaurantsViewModel(onTappedSearch: {
            let filterRestaurantsNC = MINavigationController(rootViewController: FilterRestaurantsVC())
            filterRestaurantsNC.modalPresentationStyle = .fullScreen
            self.present(filterRestaurantsNC, animated: true)            
        }, onTappedClose: {
            Gastropay.dismissViewController(viewController: self)
        }, onTappedSettings: {
            let profileVC = SettingsVC()
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }, onSelectMerchant: { merchant in
            if let merchant = merchant {
                let merchantDetailVC = RestaurantDetailVC(merchant)
                merchantDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(merchantDetailVC, animated: true)
            }
        }, onSetLoadingIndicator: { show in
            self.setLoadingState(show: show)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        extendedLayoutIncludesOpaqueBars = true
        view.addSubview(viewModel.restaurantView)
        viewModel.restaurantView.bindFrameToSuperviewBounds()
        
        if !(Service.getLocationManager()?.isAuthorized() ?? false) {
            self.setLoadingState(show: false)
        } else {
            if redirectionType == .none {
                viewModel.fetchNextRestaurants()
            }
        }
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        redirectionType = .none
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RestaurantsVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .hidden
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .white
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return .black
    }
}
