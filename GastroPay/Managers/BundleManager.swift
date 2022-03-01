***REMOVED***
***REMOVED***  BundleManager.swift
***REMOVED***  Multipay
***REMOVED***
***REMOVED***  Created by ilker sevim on 9.09.2020.
***REMOVED***  Copyright © 2020 multinet. All rights reserved.
***REMOVED***

import Foundation

class BundleManager {
    
    class func getPodBundle(_ anyClass: AnyClass = BundleManager.self)->Bundle{
        
        let bundleTemp = Bundle(for: anyClass.self)
        let bundleURL = bundleTemp.resourceURL?.appendingPathComponent("\(Strings.bundleName).bundle")
        return Bundle(url: bundleURL!) ?? Bundle.main
        
    }
    
}
