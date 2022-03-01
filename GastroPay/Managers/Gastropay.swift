***REMOVED***
***REMOVED***  Multipay.swift
***REMOVED***  Multipay
***REMOVED***
***REMOVED***  Created by ilker sevim on 2.10.2020.
***REMOVED***  Copyright © 2020 multinet. All rights reserved.
***REMOVED***

import Foundation
import UIKit

public protocol GastropayDelegate : AnyObject {
    
    ***REMOVED***MARK: - Login Methods
    func loginSucceed(token: String?)
    func loginFailed(error:Error)
    
    ***REMOVED***MARK: - Payment

    func paymentSucceed()
}

public enum APIType : Int, CaseIterable {
    case prod = 1
    case pilot = 2
    case test = 3
    case dev = 4
}

public class Gastropay {
    
    private init() { }
    
    weak static var delegate: GastropayDelegate?
    
    static var devModeActive = false
    
    public class func start(vcToPresent: UIViewController, accessToken: String? = nil, delegate:GastropayDelegate? = nil, languageCode: String? = nil, apiType: APIType = .prod, devMode: Bool = false, obfuscationSalt: String)
    {
        Gastropay.devModeActive = devMode
        Gastropay.delegate = delegate
        
***REMOVED***        if let language = languageCode, language.count > 0{
***REMOVED***            CoreManager.shared.language = language
***REMOVED***        }
        
        Auth.obfuscationSalt = obfuscationSalt
    
        Service.getAuthenticationManager()?.setToken(for: .AccessToken, token: accessToken)

        ServiceUrl.setApiType(kApiType: apiType)
        
        FontHelper.registerAllFonts()
        Service.createService()
        
        getSettings()
        
        if accessToken == nil || accessToken?.count ?? 0 <= 0 {
            Gastropay.createLoginAndPresent(vcToPresent: vcToPresent)
        }
        else{
            getUser()
            createTabBarAndPresent(vcToPresent: vcToPresent)
        }
    }
    
    public class func getUser(completion: (()->())? = nil) {
        Service.getAPI()?.getUser { (result) in
            switch result {
            case .success(let user):
                Service.getAuthenticationManager()?.user = user
                Service.getAuthenticationManager()?.sendAuthenticationStatusNotification(status: .LoggedIn)
                completion?()
            case .failure(let error):
                
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }
    
    public class func getSettings(completion: (()->())? = nil) {
        Service.getAPI()?.getSettings { result in
            switch result {
            case .success(let settings):
                Service.setSettings(settings)
            case .failure(_):
                break
            }
        }
    }
    
    private class func createLoginAndPresent(vcToPresent: UIViewController){
        
        let loginVC = LoginVC(viewModel: nil)
        loginVC.hidesBottomBarWhenPushed = true
        loginVC.modalPresentationStyle = .fullScreen
        
        let navCont = UINavigationController(rootViewController: loginVC)
        navCont.modalPresentationStyle = .fullScreen
        
        vcToPresent.present(navCont, animated: true, completion: nil)
    }
    
    public class func createTabBarAndPresent(vcToPresent: UIViewController){
        let tb = TabbarProvider.createTabbarController(delegate: nil)
        tb.modalPresentationStyle = .fullScreen
        vcToPresent.present(tb, animated: true, completion: nil)
    }
    
    public class func dismissViewController(viewController: UIViewController) {
        viewController.dismiss(animated: true)
        
        Service.resetAllServiceInstances()
    }
    
    ***REMOVED***MARK: SDK FUNCTIONS
    
}
