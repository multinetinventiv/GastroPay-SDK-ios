//
//  Foundation.swift
//  Inventiv+CommonModule
//
//  Created by  on 3.03.2020.
//

import Foundation

public extension String {
    var local : String {
        if self == "" {
            return ""
        }
        
        let bundleURL = Bundle(for: Strings.self).resourceURL?.appendingPathComponent("\(Strings.bundleName).bundle")
        
        guard let bundle =  Bundle(url: bundleURL!) else {
            return ""
        }

        let localizedStr = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        let doubleNewLine = "\\n"
        let singleNewLine = "\n"
        
        return localizedStr.replacingOccurrences(of: doubleNewLine, with: singleNewLine)
    }

}

public extension Double {

    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

}

public extension Date {

    func toRemainingTimeText(from: Date = Date()) -> String {
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: from, to: self)

        if (diffDateComponents.day ?? 0) > 0 {
            return "\(diffDateComponents.day!) gün kaldı"
        }

        if (diffDateComponents.hour ?? 0) > 0 {
            return "\(diffDateComponents.hour!) saat kaldı"
        }

        if (diffDateComponents.minute ?? 0) > 0 {
            return "\(diffDateComponents.minute!) dakika kaldı"
        }

        if (diffDateComponents.second ?? 0) > 0 {
            return "\(diffDateComponents.second!) dakika kaldı"
        }

        return "Geçti"
    }

}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
        
    }
}
