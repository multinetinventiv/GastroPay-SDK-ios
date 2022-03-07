//
//  MyNavigationController.swift
//  Multipay
//
//  Created by ilker sevim on 23.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func openAddCardFromOTP(){
//
//        self.popToRootViewController(animated: false)
//        let addCardVC = AddCardVC.instantiate()
//        self.pushViewController(addCardVC, animated: true)
//
//    }
//
//    func openWalletFromOTP(){
//        let walletVC = WalletViewController.instantiate()
//        self.pushViewController(walletVC, animated: true)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.viewControllers.remove(at: self.viewControllers.count-2)
//        }
//    }
//
//    func openWalletFromLogin(){
//        let walletVC = WalletViewController.instantiate()
//        self.pushViewController(walletVC, animated: false)
//    }
//
//    func openAddCardFromWallet(){
//        let addCardVC = AddCardVC.instantiate()
//        self.pushViewController(addCardVC, animated: true)
//    }
}

//MARK: - StoryboardInstantiable
//extension MyNavigationController: StoryboardInstantiable {
//    
//    static var storyboardName: String { return "Main" }
//    static var storyboardIdentifier: String? { return "FirstNavigationController" }
//}

