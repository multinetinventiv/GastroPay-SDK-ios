//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import UIKit

class Auth {
    
    private init() { }
    static let shared = Auth()
    static let sharedInstance = Auth.shared
    
    let defaults = UserDefaults.standard
    static let defaultsKey = "MY-API-KEY"
    
    internal static var appToken: String?
    internal static var obfuscationSalt: String?
    
  func logout() {
    
    Service.getAuthenticationManager()?.setToken(for: .AccessToken, token: nil)
    Gastropay.delegate?.loginSucceed(token: nil)
  }
    
}
