//
//  TabbarPayItemContentView.swift
//  GastroPay
//
//  Created by  on 25.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit


class TabbarPayItemContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backdropColor = ColorHelper.Tabbar.backdropColor
        textColor = ColorHelper.Tabbar.textColor
        highlightBackdropColor = ColorHelper.Tabbar.backdropColor
        contentMode = .scaleAspectFit
        renderingMode = .alwaysOriginal
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {
        super.updateLayout()
        self.titleLabel.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height - 12)
        self.imageView.frame = CGRect(x: (self.bounds.size.width / 2.0) - 15.0, y: (self.bounds.size.height / 3.0) - 15.0 , width: 30.0, height: 30.0)

        self.imageView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
    }

    public override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }, completion: { completed in
            completion?()
        })
    }

    public override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }, completion: { completed in
            completion?()
        })
    }
}
