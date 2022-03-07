//
//  Extensions.swift
//  Shared
//
//  Created by  on 18.06.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Foundation
import Then
import YPNavigationBarTransition

public func getResourceBundle(anyClass: AnyClass = Gastropay.self)->Bundle?{
    return BundleManager.getPodBundle(anyClass)
}

public extension Date {
    func toRemainingTimeText(_ to: Date) -> String {
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: to)

        if let diffDays = diffDateComponents.day, diffDays > 0 {
            return diffDays > 1 ?
                Localization.TimeAgo.days.local.replacingOccurrences(of: "%1$s", with: "\(diffDays)") :
                Localization.TimeAgo.day.local.replacingOccurrences(of: "%1$s", with: "\(diffDays)")
        }

        if let diffHours = diffDateComponents.hour, diffHours > 0 {
            return diffHours > 1 ?
                Localization.TimeAgo.days.local.replacingOccurrences(of: "%1$s", with: "\(diffHours)") :
                Localization.TimeAgo.day.local.replacingOccurrences(of: "%1$s", with: "\(diffHours)")
        }

        if let diffMinutes = diffDateComponents.minute, diffMinutes > 0 {
            return diffMinutes > 1 ?
                Localization.TimeAgo.minutes.local.replacingOccurrences(of: "%1$s", with: "\(diffMinutes)") :
                Localization.TimeAgo.minute.local.replacingOccurrences(of: "%1$s", with: "\(diffMinutes)")
        }

        if let diffSeconds = diffDateComponents.second {
            return diffSeconds > 1 ?
                Localization.TimeAgo.seconds.local.replacingOccurrences(of: "%1$s", with: "\(diffSeconds)") :
                Localization.TimeAgo.second.local.replacingOccurrences(of: "%1$s", with: "\(diffSeconds)")
        }

        return Localization.TimeAgo.missed.local
    }
}

public extension String {

    func formatNumbers(withMask mask: String = "0 (XXX) XXX XX XX") -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                guard numbers.indices.contains(index) else { continue }

                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }

}

public extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

public extension UIViewController {
    
    func getLocalizedString(key:String, comment:String = "", anyClass: AnyClass) -> String{
        let path = Bundle(for: anyClass.self).path(forResource: Strings.bundleName, ofType: "bundle")!
        let bundle = Bundle(path: path) ?? Bundle.main
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }

    func add(childViewController viewController: UIViewController) {
        viewController.willMove(toParent: self)

        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    func remove(childViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()

        viewController.didMove(toParent: nil)
    }

}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

public extension Int {
    var boolValue: Bool { return self != 0 }
}

extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            return false
        }

        return true
    }
}

extension YPNavigationController: NavigationBarConfigureStyle {

    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .styleBlack
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return .white
    }

}
