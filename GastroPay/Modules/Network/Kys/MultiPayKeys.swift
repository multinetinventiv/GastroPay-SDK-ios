***REMOVED***
***REMOVED***  Keys.swift
***REMOVED***  Multipay
***REMOVED***
***REMOVED***  Created by ilker sevim on 8.09.2020.
***REMOVED***  Copyright © 2020 multinet. All rights reserved.
***REMOVED***

import Foundation

private let https = "https:***REMOVED***"

private enum ObfsctfConstants {
    static let DevAPI_BASE_DOMAIN_URL: [UInt8] = [37, 64, 50, 7, 32, 78, 102, 6, 47, 23, 38, 21, 58, 27, 57, 9, 31, 18, 69, 31, 21, 9, 78, 44, 91, 36, 92, 45, 74, 32, 76, 56, 47, 83, 33, 68, 51, 68, 61, 79, 61, 1, 32, 17, 60, 8, 61, 3]

    static let TestAPI_BASE_DOMAIN_URL: [UInt8] = [53, 64, 55, 94, 106, 74, 40, 76, 41, 5, 33, 19, 39, 4, 40, 17, 75, 94, 84, 6, 81, 87, 70, 44, 73, 32, 70, 60, 66, 59, 76, 34, 36, 87, 50, 67, 36, 72, 56]
    
    static let PilotAPI_BASE_DOMAIN_URL: [UInt8] = [38, 68, 48, 79, 48, 76, 50, 79, 39, 10, 36, 2, 59, 31, 49, 6, 28, 0, 80, 4, 78, 16, 76, 39, 76]
    
    static let ProdAPI_BASE_DOMAIN_URL: [UInt8] = [38, 68, 48, 79, 48, 76, 50, 79, 39, 10, 36, 2, 59, 31, 49, 6, 28, 0, 80, 4, 78, 16, 76, 39, 76]
}

public class DevSdkConfig {
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.DevAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)"
    public static let API_TYPE=4
}

public class TestSdkConfig {
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.TestAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)"
    public static let API_TYPE=3
}

public class PilotSdkConfig {
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.PilotAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)"
    public static let API_TYPE=2
}

public class ProdSdkConfig {
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.ProdAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)"
    public static let API_TYPE=1
}
