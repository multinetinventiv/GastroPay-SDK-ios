//
//  BundleManager.swift
//  Multipay
//
//  Created by ilker sevim on 9.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation

class BundleManager {
    
    class func getPodBundle(_ anyClass: AnyClass = BundleManager.self)->Bundle{
        
        let bundleTemp = Bundle(for: anyClass.self)
        let bundleURL = bundleTemp.resourceURL?.appendingPathComponent("\(Strings.bundleName).bundle")
        return Bundle(url: bundleURL!) ?? Bundle.main
        
    }
    
}
