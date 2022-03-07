//
//  UIColor.swift
//  Shared
//
//  Created by  on 25.11.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

public extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }
}
