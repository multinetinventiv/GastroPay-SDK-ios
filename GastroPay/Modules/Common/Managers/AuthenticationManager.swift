***REMOVED***
***REMOVED***  AuthenticationManager.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***

import Foundation

import NotificationCenter

public enum AuthenticationStatus {
    case LoggedIn
    case Guest
}

public struct AuthenticationManagerNotifications {
    public static let statusChanged = NSNotification.Name.init("miAuthenticationStatusChanged")
}

public class AuthenticationManager<UserModel: Codable> {
    public var user: UserModel?

    public enum TokenType {
        case AccessToken
        case RefreshToken
    }

    private let keychain: UserDefaults!

    public init(serviceId: String) {
        keychain = UserDefaults(suiteName: serviceId) ?? UserDefaults(suiteName: "GastropaySDK") ?? UserDefaults()
    }

    public func setUser(user: UserModel) {
        self.user = user
    }

    public func userLoggedInWith(accessToken: String, refreshToken: String) {
        self.setToken(for: .AccessToken, token: accessToken)
        self.setToken(for: .RefreshToken, token: refreshToken)
        sendAuthenticationStatusNotification(status: .LoggedIn)
    }

    public func userLoggedOut() {
        self.setToken(for: .AccessToken, token: nil)
        self.setToken(for: .RefreshToken, token: nil)
        self.user = nil
        sendAuthenticationStatusNotification(status: .Guest)
    }

    public func isUserAuthenticated() -> Bool {
        return self.getToken(for: .AccessToken) != nil && self.getToken(for: .RefreshToken) != nil
    }

    public func sendAuthenticationStatusNotification(status: AuthenticationStatus) {
        NotificationCenter.default.post(name: AuthenticationManagerNotifications.statusChanged, object: nil, userInfo: ["status": status])
    }

    public func setToken(for type: TokenType, token: String?) {
            switch type {
            case .AccessToken:
                if let token = token {
                    keychain.set(token, forKey: "accessToken")
                    Gastropay.delegate?.loginSucceed(token: token)
                }
                else{
                    Gastropay.delegate?.loginSucceed(token: nil)
                    keychain.removeObject(forKey: "accessToken")
                }
            default:
                if let token = token {
                    keychain.set(token, forKey: "refreshToken")
                }
                else{
                    keychain.removeObject(forKey: "refreshToken")
                }
            }
    }
    
    public func getToken(for type: TokenType) -> String? {
        switch type {
        case .AccessToken:
            return keychain.object(forKey: "accessToken") as? String
        default:
            return keychain.object(forKey: "refreshToken") as? String
        }
    }
}
