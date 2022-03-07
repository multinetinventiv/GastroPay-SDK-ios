//
//  ViewController.swift
//  Sample
//
//  Created by ilker sevim on 25.05.2021.
//

import UIKit
import Gastropay

class ViewController: UIViewController {
    
    public let userDefaults = UserDefaults.standard
    
    var accessToken: String?
    
    //MARK: - IBOUTLETS
    
    @IBOutlet weak var testModeSwitch: UISwitch!
    
    //MARK: -

    var lastSelectedApiType:APIType?{
        
        get{
            let apiType = userDefaults.object(forKey: "lastSelectedApiType") as? Int
            return APIType(rawValue: apiType ?? 3)
        }
        set{
            userDefaults.set(newValue?.rawValue, forKey: "lastSelectedApiType")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func startClicked(_ sender: Any) {
        
        Gastropay.start(vcToPresent: self, accessToken: accessToken, delegate: self, apiType: lastSelectedApiType!, obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType!)!)
    }
    
    @IBAction func clearAccessTokenClicked(_ sender: Any) {
        self.accessToken = nil
    }
    
}

//MARK: -

extension ViewController{
    
    func getObfuscationSalt(apiType:APIType) -> String?{
        var obfuscationSalt:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["obfuscationSalt"]
            obfuscationSalt = tempAppToken as? String
        }
        return obfuscationSalt
    }
    
    func getWalletToken(apiType:APIType) -> String?{
        
        var appToken:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["walletToken"]
            appToken = tempAppToken as? String
        }
        
        return appToken
    }
    
    func getAuthToken(apiType:APIType) -> String?{
        
        var appToken:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["authenticationToken"]
            appToken = tempAppToken as? String
        }
        
        return appToken
    }
    
    func getAppToken(apiType:APIType) -> String{
        
        var appToken = ""
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["appToken"]
            appToken = tempAppToken as! String
        }
        
        return appToken
    }
    
    func getReferenceNumber(apiType:APIType) -> String{
        
        var appToken = ""
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["referenceNumber"]
            appToken = tempAppToken as! String
        }
        
        return appToken
    }
    
}

//MARK: - To read and write to config plist files

extension ViewController{
    
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
    
    /*
    func getConfirmPaymentDict(apiType:APIType) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(apiType: apiType){
            
            let paymentConfirmDict = plistDict["ConfirmPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        }
        else{
            return nil
        }
    }
    */
    
    func saveToPropertyList() {
        
        let apiType:APIType = self.lastSelectedApiType!
        
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
        
        let paths = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist")
        let path = paths
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path!)))
        {
            do {
                let bundlePath : NSString = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist")! as NSString
                
                try fileManager.copyItem(atPath: bundlePath as String, toPath: path!)
            }catch {
                print(error)
            }
        }
        
        let tempDict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        
        //tempDict["authenticationToken"] = self.selectedAuthToken
        
        //tempDict["walletToken"] = self.selectedWalletToken
        
        tempDict.write(toFile: path!, atomically: true)
    }
}

//MARK: GastropayDelegate methods
extension ViewController: GastropayDelegate{
    func paymentSucceed() {
        print("Payment succeeded")
    }
    
    func loginSucceed(token: String?) {
        accessToken = token
        print("Access Token :\(String(describing: token))")
    }
    
    func loginFailed(error: Error) {
        print("login failed error:\(error)")
    }
}

