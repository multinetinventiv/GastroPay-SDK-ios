***REMOVED***
***REMOVED***  GastroAPITokenProvider.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***



public class GastroAPITokenProvider: NetworkAuthenticationTokenProvider {
    public var accessToken: String? {
        get {
            return Service.getAuthenticationManager()?.getToken(for: .AccessToken)
        }
        set {
            Service.getAuthenticationManager()?.setToken(for: .AccessToken, token: newValue)
        }
    }

    public var refreshToken: String? {
        get {
            return Service.getAuthenticationManager()?.getToken(for: .RefreshToken)
        }
        set {
            Service.getAuthenticationManager()?.setToken(for: .RefreshToken, token: newValue)
        }
    }
}
