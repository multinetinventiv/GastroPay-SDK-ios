***REMOVED***
***REMOVED***  AppDelegate.swift
***REMOVED***  Sample
***REMOVED***
***REMOVED***  Created by ilker sevim on 25.05.2021.
***REMOVED***

import UIKit

import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ***REMOVED*** Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        } else {
            ***REMOVED*** Fallback on earlier versions
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    ***REMOVED*** MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        ***REMOVED*** Called when a new scene session is being created.
        ***REMOVED*** Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        ***REMOVED*** Called when the user discards a scene session.
        ***REMOVED*** If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        ***REMOVED*** Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

