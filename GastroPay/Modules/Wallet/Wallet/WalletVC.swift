//
//  Wallet.swift
//  Wallet
//
//  Created by  on 7.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then
import NotificationCenter
import YPNavigationBarTransition

public class WalletVC: MIViewController, NavigationBarConfigureStyle {
    private var currentVC: (UIViewController & NavigationBarConfigureStyle)? {
        willSet {
            if let currentVC = self.currentVC {
                self.remove(childViewController: currentVC)
            }
        }
        didSet {
            if let currentVC = self.currentVC {
                self.add(childViewController: currentVC)
                yp_refreshNavigationBarStyle()
            }
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentVC?.preferredStatusBarStyle ?? .default
    }

    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return currentVC?.yp_navigtionBarConfiguration() ?? .backgroundStyleTransparent
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return currentVC?.yp_navigationBarTintColor() ?? .white
    }

    public func yp_navigationBackgroundColor() -> UIColor! {
        return currentVC?.yp_navigationBackgroundColor?() ?? .white
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
//        extendedLayoutIncludesOpaqueBars = true
        //        currentVC = Service.getAuthenticationManager().isUserAuthenticated() ? WalletLoginVC() : WalletGuestVC()
//        currentVC = WalletLoginVC()
//        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChanged), name: AuthenticationManagerNotifications.statusChanged, object: nil)
    }

//    @objc func loginStateChanged() {
//        currentVC = nil
//
//        if Service.getAuthenticationManager().isUserAuthenticated() {
//            currentVC = WalletLoginVC()
//        } else {
//            currentVC = WalletGuestVC()
//        }
//    }

}
