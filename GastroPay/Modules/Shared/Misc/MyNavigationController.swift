***REMOVED***
***REMOVED***  MyNavigationController.swift
***REMOVED***  Multipay
***REMOVED***
***REMOVED***  Created by ilker sevim on 23.09.2020.
***REMOVED***  Copyright © 2020 multinet. All rights reserved.
***REMOVED***

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ***REMOVED*** Do any additional setup after loading the view.
    }
    
***REMOVED***    func openAddCardFromOTP(){
***REMOVED***
***REMOVED***        self.popToRootViewController(animated: false)
***REMOVED***        let addCardVC = AddCardVC.instantiate()
***REMOVED***        self.pushViewController(addCardVC, animated: true)
***REMOVED***
***REMOVED***    }
***REMOVED***
***REMOVED***    func openWalletFromOTP(){
***REMOVED***        let walletVC = WalletViewController.instantiate()
***REMOVED***        self.pushViewController(walletVC, animated: true)
***REMOVED***        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
***REMOVED***            self.viewControllers.remove(at: self.viewControllers.count-2)
***REMOVED***        }
***REMOVED***    }
***REMOVED***
***REMOVED***    func openWalletFromLogin(){
***REMOVED***        let walletVC = WalletViewController.instantiate()
***REMOVED***        self.pushViewController(walletVC, animated: false)
***REMOVED***    }
***REMOVED***
***REMOVED***    func openAddCardFromWallet(){
***REMOVED***        let addCardVC = AddCardVC.instantiate()
***REMOVED***        self.pushViewController(addCardVC, animated: true)
***REMOVED***    }
}

***REMOVED***MARK: - StoryboardInstantiable
***REMOVED***extension MyNavigationController: StoryboardInstantiable {
***REMOVED***    
***REMOVED***    static var storyboardName: String { return "Main" }
***REMOVED***    static var storyboardIdentifier: String? { return "FirstNavigationController" }
***REMOVED***}

