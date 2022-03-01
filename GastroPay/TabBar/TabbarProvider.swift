***REMOVED***
***REMOVED***  TabbarProvider.swift
***REMOVED***  GastroPay
***REMOVED***
***REMOVED***  Created by  on 11.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

***REMOVED*** Import third party
import UIKit
import NotificationCenter

class TabbarProvider {

    class func createTabbarController(delegate: UITabBarControllerDelegate? = nil) -> ESTabBarController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate

        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
            tabBar.itemEdgeInsets = .init(top: 0, left: 0, bottom: UIDevice.current.hasNotch ? 20 : 0, right: 0)
        }

        tabBarController.shouldHijackHandler = {(tabBarController, vc, index) -> Bool in
            return index == 1
        }

        tabBarController.didHijackHandler = {(uiTabBarController, vc, index) in
            paymentWithQR()
        }

        tabBarController.viewControllers = getNavigationControllers()
        
        Service.registerESTabbarControler(tabBarController: tabBarController)

        return tabBarController
    }

    class func getNavigationControllers() -> [UINavigationController] {
        let nav1 = MINavigationController(rootViewController: RestaurantsVC())
        nav1.tabBarItem = ESTabBarItem(
            TabbarItemContentView(),
            title: Localization.Home.tabBarRestaurantsTitle.local,
            image: ImageHelper.TabbarIcons.restaurants
        )

        let nav2 = MINavigationController()
        nav2.tabBarItem = ESTabBarItem(
            TabbarPayItemContentView(),
            title: Localization.Home.tabBarPayTitle.local,
            image: ImageHelper.TabbarIcons.payWhite,
            selectedImage: ImageHelper.TabbarIcons.pay
        )
        
        let nav3 = MINavigationController(rootViewController: TransactionsVC())
        nav3.tabBarItem = ESTabBarItem(
            TabbarItemContentView(),
            title: Localization.Home.tabBarWalletTitle.local,
            image: ImageHelper.TabbarIcons.wallet
        )

        return [nav1, nav2, nav3]
    }
    
    class func paymentWithQR() {
        Service.getTabbarController()?.view.setLoadingState(show: true)
        Service.getAPI()?.getCreditCards { (result) in
            switch(result) {
            case .success(let cards):
                var nav: MINavigationController!
                
                if cards.isEmpty {
                } else {
                    nav = MINavigationController(rootViewController: PayWithQRVC())
                    nav.modalPresentationStyle = .currentContext
                    
                    Service.getTabbarController()?.view.setLoadingState(show: false)
                    Service.getTabbarController()?.present(nav, animated: false)
                }
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
                Service.getTabbarController()?.view.setLoadingState(show: false)
            }
        }
    }
}

extension ESTabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 56
        return sizeThatFits
    }
}
