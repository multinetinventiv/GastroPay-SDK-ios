***REMOVED***
***REMOVED***  MINavigationController.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 16.06.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import Foundation
import YPNavigationBarTransition

public class MINavigationController: YPNavigationController {
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        if let topVC = viewControllers.last {
            ***REMOVED*** return the status property of each VC, look at step 2
            return topVC.preferredStatusBarStyle
        }

        return super.preferredStatusBarStyle
    }

    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        if let topVC = viewControllers.last {
            ***REMOVED*** return the status property of each VC, look at step 2
            return topVC.preferredStatusBarUpdateAnimation
        }

        return super.preferredStatusBarUpdateAnimation
    }

    override public var childForStatusBarStyle: UIViewController? {
        if let topVC = viewControllers.last {
            ***REMOVED*** return the status property of each VC, look at step 2
            return topVC.childForStatusBarStyle
        }

        return super.childForStatusBarStyle
    }
}
