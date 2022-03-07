//
//  Service.swift
//  Shared
//
//  Created by  on 17.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//


import Foundation
import Swinject
import XCGLogger
import YPNavigationBarTransition

public class Service {
    public enum TabbarTabNames: Int {
        case home = 0
        case restaurants = 1
        case campaigns = 3
        case wallet = 4
    }

    private static var shared: Service?

    let di: Container!

    var settings: NetworkModels.Settings?

    init() {
        di = Container()

        di.register(AuthenticationManager<User>.self) { _ in AuthenticationManager(serviceId: "GastropaySDK") }
            .inObjectScope(.container)

        di.register(LocationManager.self) { _ in LocationManager() }
            .inObjectScope(.container)

        di.register(GastroAPI.self) { _ in GastroAPI() }
            .inObjectScope(.container)

        di.register(MIPopupManager.self) { _ in MIPopupManager() }
            .inObjectScope(.container)

        di.register(NetworkModels.Settings?.self) { _ in self.settings }
            .inObjectScope(.container)

        di.register(XCGLogger.self, factory: { _ in
            let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)

            var infoPlist: NSDictionary?

            if let path = Bundle(identifier: "com.multinetinventiv.gastropay.Shared")?.path(forResource: "Info", ofType: "plist") {
                infoPlist = NSDictionary(contentsOfFile: path)
            }

            let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
            if let infoPlist = infoPlist, let loggerDebugEnabledValue = infoPlist["LOGGER_DEBUG_ENABLED"] as? String, let loggerDebugEnabled = Bool(loggerDebugEnabledValue) {
                systemDestination.outputLevel = loggerDebugEnabled ? .debug : .none
            } else {
                systemDestination.outputLevel = .none
            }
            systemDestination.showLogIdentifier = true
            systemDestination.showFunctionName = true
            systemDestination.showThreadName = true
            systemDestination.showLevel = true
            systemDestination.showFileName = true
            systemDestination.showLineNumber = true
            systemDestination.showDate = true

            let emojiLogFormatter = PrePostFixLogFormatter()
            emojiLogFormatter.apply(prefix: "🗯🗯🗯 ", postfix: " 🗯🗯🗯", to: .verbose)
            emojiLogFormatter.apply(prefix: "🧑🏻‍💻🧑🏻‍💻🧑🏻‍💻 ", postfix: " 🧑🏻‍💻🧑🏻‍💻🧑🏻‍💻", to: .debug)
            emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: " ℹ️ℹ️ℹ️", to: .info)
            emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️⚠️ ", postfix: " ⚠️⚠️⚠️⚠️", to: .warning)
            emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: " ‼️⚠️⚠️‼️", to: .error)
            emojiLogFormatter.apply(prefix: "💣💣💣 ", postfix: " 💣💣💣", to: .severe)
            log.formatters = [emojiLogFormatter]

            log.add(destination: systemDestination)

            return log
        })

        di.register(RestaurantManager.self, name: "AllRestaurantManager") { _ in
            RestaurantManager()
        }.inObjectScope(.container)

        di.register(RestaurantManager.self, name: "BonusRestaurantManager") { _ in
            RestaurantManager()
        }.inObjectScope(.container)

        di.register(UserDefaults.self, name: "UserPreferences") {_ in
            UserDefaults.standard
        }.inObjectScope(.container)

    }
    
    public class func registerESTabbarControler(tabBarController: ESTabBarController) {
        shared?.di.register(ESTabBarController.self) { _ in tabBarController }
            .inObjectScope(.container)
    }

    public class func getLocationManager() -> LocationManager? {
        return shared?.di.resolve(LocationManager.self)
    }

    public class func getAPI() -> GastroAPI? {
        return shared?.di.resolve(GastroAPI.self)
    }

    public class func getTabbarController() -> ESTabBarController? {
        return shared?.di.resolve(ESTabBarController.self)
    }

    public class func getPopupManager() -> MIPopupManager? {
        return shared?.di.resolve(MIPopupManager.self)
    }

    public class func getAuthenticationManager() -> AuthenticationManager<User>? {
        return shared?.di.resolve(AuthenticationManager.self)
    }

    public class func getLogger() -> XCGLogger? {
        return shared?.di.resolve(XCGLogger.self)
    }

    public class func getSettings() -> NetworkModels.Settings? {
        return shared?.settings
    }

    public class func setSettings(_ settings: NetworkModels.Settings) {
        shared?.settings = settings
    }

    public class func getEarnableRestaurantsManager() -> RestaurantManager? {
        return shared?.di.resolve(RestaurantManager.self, name: "BonusRestaurantManager")
    }

    public class func getSpendableRestaurantsManager() -> RestaurantManager? {
        return shared?.di.resolve(RestaurantManager.self, name: "AllRestaurantManager")
    }

    public class func resetRestaurantManagers(withMerchantList: MerchantList? = nil) {
        for manager in [getEarnableRestaurantsManager(), getSpendableRestaurantsManager()] where withMerchantList != nil || manager?.page != 1 || manager?.tags != nil {
            manager?.resetData()

            if let merchantList = withMerchantList {
                manager?.tags = [merchantList.tagId]
            }

            if getLocationManager()?.lastLocation != nil {
                manager?.fetchNextRestaurants()
            } else {
                manager?.startListeningLocationEvents()
                getLocationManager()?.startListeningLocationEvents()
            }
        }
    }

    public class func getUserPreferencesManager() -> UserDefaults? {
        return shared?.di.resolve(UserDefaults.self, name: "UserPreferences")!
    }

    public class func setLoadingStateFor(tabName: TabbarTabNames, state: Bool) {
        Service.getTabbarController()?.viewControllers?[tabName.rawValue].view.setLoadingState(show: state)
    }
    
    public class func resetAllServiceInstances() {
        if let locationManager = Service.getSpendableRestaurantsManager() {
            Service.getLocationManager()?.removeDelegate(locationManager)
        }
        
        shared?.di.removeAll()
        shared = nil
    }
    
    public class func createService() {
        shared = Service()
    }
}

public struct ServiceUrl {
    
    static func setApiType(kApiType: APIType) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(kApiType.rawValue, forKey: "apiType")
        userDefaults.synchronize()
        
    }
    
    static func readApiType() -> APIType {
        if let kApiType = UserDefaults.standard.object(forKey: "apiType") as? Int {
            switch kApiType {
            case 1:
                return .prod
            case 2:
                return .pilot
            case 3:
                return .test
            case 4:
                return .dev
            default:
                return .prod
            }
        }
        return .prod
    }
    
    static func isPROD() -> Bool {
        return ServiceUrl.readApiType() == .prod ? true : false
    }
    
    static func isPILOT() -> Bool {
        return ServiceUrl.readApiType() == .pilot ? true : false
    }
    
    static func isTEST() -> Bool {
        return ServiceUrl.readApiType() == .test ? true : false
    }
    
    static func getBaseURL(isSdk: Bool = true) -> String {
        switch ServiceUrl.readApiType() {
        case .dev:
                return DevSdkConfig.API_BASE_PATH
        case .test:
                return TestSdkConfig.API_BASE_PATH
        case .pilot:
                return PilotSdkConfig.API_BASE_PATH
        case .prod:
                return ProdSdkConfig.API_BASE_PATH
        }
    }
    
    static func getApiBaseDomainUrl(isSdk: Bool = false) -> String {
        
        switch ServiceUrl.readApiType() {
        case .dev:
                return DevSdkConfig.API_BASE_DOMAIN_URL
        case .test:
                return TestSdkConfig.API_BASE_DOMAIN_URL
        case .pilot:
                return PilotSdkConfig.API_BASE_DOMAIN_URL
        case .prod:
                return ProdSdkConfig.API_BASE_DOMAIN_URL
        }
    }
    
    static func getURL(_ serviceName:String, isSdk: Bool = false) -> String {
        return getBaseURL(isSdk: isSdk) + "/" + serviceName
    }
    
    
    static func getToken() -> String {
        
        if let token = Auth.appToken{
            return token
        }
        else{
            return ""
        }
        
        
    }
    
}
