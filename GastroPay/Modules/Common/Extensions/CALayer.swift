***REMOVED***
***REMOVED***  CALayer.swift
***REMOVED***  Inventiv+CommonModule
***REMOVED***
***REMOVED***  Created by  on 17.01.2020.
***REMOVED***

import Foundation

public extension CALayer {

    func applySketchShadow(
        color: UIColor = UIColor(red: 248.0 / 255.0, green: 248.0 / 255.0, blue: 248.0 / 255.0, alpha: 0.5),
        alpha: Float = 1.0,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 10,
        spread: CGFloat = 0,
        cornerRadius: Int = 0) {
        self.cornerRadius = CGFloat(cornerRadius)
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

}
