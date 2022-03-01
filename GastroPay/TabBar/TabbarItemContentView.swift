***REMOVED***
***REMOVED***  TabbarItemContentView.swift
***REMOVED***  GastroPay
***REMOVED***
***REMOVED***  Created by  on 25.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit


class TabbarItemContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = ColorHelper.Tabbar.textColor
        iconColor = ColorHelper.Tabbar.iconColor

        highlightTextColor = ColorHelper.Tabbar.highlightTextColor
        highlightIconColor = ColorHelper.Tabbar.highlightIconColor

        backdropColor = ColorHelper.Tabbar.backdropColor
        highlightBackdropColor = ColorHelper.Tabbar.backdropColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        self.imageView.sizeToFit()
        self.imageView.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 3.0)
        self.titleLabel.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height - 12)
    }
}
