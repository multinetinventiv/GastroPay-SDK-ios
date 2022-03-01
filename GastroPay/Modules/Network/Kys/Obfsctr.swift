***REMOVED***
***REMOVED***  Obfsctr.swift
***REMOVED***  Multipay
***REMOVED***
***REMOVED***  Created by ilker sevim on 27.01.2021.
***REMOVED***

import Foundation

class Obfuscator {
    
    ***REMOVED*** MARK: - Variables
    
    ***REMOVED***/ The salt used to obfuscate and reveal the string.
    private var salt: String = "\(String(describing: Obfuscator.self))\(String(describing: NSObject.self))\(String(describing: Obfuscator.self))"
    
    ***REMOVED*** MARK: - Initialization
    
    init() {
        
        let apiTypeInt = UserDefaults.standard.object(forKey: "lastSelectedApiType") as? Int
        let apiType = APIType(rawValue: apiTypeInt ?? 3) ?? APIType.test
        
        let obfsSalt = getObfuscationSalt(apiType: apiType)
        
        if let tempSalt = obfsSalt{
            salt = tempSalt
        }
        
    }
    
    init(with salt: String) {
        self.salt = salt
    }
    
    
    ***REMOVED*** MARK: - Instance Methods
    
    /**
     This method obfuscates the string passed in using the salt
     that was used when the Obfuscator was initialized.
     
     - parameter string: the string to obfuscate
     
     - returns: the obfuscated string in a byte array
     */
    func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        #if DEVELOPMENT
        print("Salt used: \(self.salt)\n")
        print("Swift Code:\n************")
        print("***REMOVED*** Original \"\(string)\"")
        print("let key: [UInt8] = \(encrypted)\n")
        #endif
        
        return encrypted
    }
    
    /**
     This method reveals the original string from the obfuscated
     byte array passed in. The salt must be the same as the one
     used to encrypt it in the first place.
     
     - parameter key: the byte array to reveal
     
     - returns: the original string
     */
    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }
}

extension Obfuscator{
    
    func getObfuscationSalt(apiType:APIType) -> String?{
        var obfuscationSalt:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["obfuscationSalt"]
            obfuscationSalt = tempAppToken as? String
        }
        
        if obfuscationSalt == nil || obfuscationSalt?.count ?? 0 < 1{
            obfuscationSalt = Auth.obfuscationSalt
        }
            
        return obfuscationSalt
    }
    
    
    func getPlist(apiType:APIType) -> [String:AnyObject]?
    {
        var apiFileNameStart = ""
        
        switch apiType {
        case .dev:
            apiFileNameStart = "Dev"
            break
        case .test:
            apiFileNameStart = "Test"
            break
        case .pilot:
            apiFileNameStart = "Pilot"
            break
        case .prod:
            apiFileNameStart = "Prod"
            break
        }
        
        if  let path = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            print("xml: \(xml)")
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:AnyObject]
        }
        return nil
    }
    
}
