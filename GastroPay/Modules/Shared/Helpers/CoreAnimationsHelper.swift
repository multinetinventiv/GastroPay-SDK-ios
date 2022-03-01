***REMOVED***
***REMOVED***  CAHelper.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 17.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public struct CoreAnimationsHelper {
    public struct GradientLayer {
        public static func createBlackTopToBottom() -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                ColorHelper.Gradient.HeaderGradient.stop1.cgColor,
                ColorHelper.Gradient.HeaderGradient.stop2.cgColor,
                ColorHelper.Gradient.HeaderGradient.stop3.cgColor
            ]
            layer.locations = [0.0, 0.4, 1.0]
            return layer
        }

        public static func createBottomToTopGradientLayer() -> CAGradientLayer {
            let layer = CAGradientLayer()
            layer.colors = [
                ColorHelper.Gradient.UnitGradient.stop1.cgColor,
                ColorHelper.Gradient.UnitGradient.stop2.cgColor,
                ColorHelper.Gradient.UnitGradient.stop3.cgColor
            ]
            layer.locations = [0.0, 0.6, 1.0]
            return layer
        }
    }
}
