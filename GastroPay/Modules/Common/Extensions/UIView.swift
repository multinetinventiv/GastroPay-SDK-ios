***REMOVED***
***REMOVED***  UIView.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 15.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public extension UIView {
    private struct AssociatedViewKeys {
        static var loadingIndicatorKey = "miLoadingIndicatorKey"
        static var loadingIndicatorBackgroundKey = "miLoadingIndicatorBackgroundKey"
    }

    var loadingIndicator: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedViewKeys.loadingIndicatorKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedViewKeys.loadingIndicatorKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loadingSpinnerBackground: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedViewKeys.loadingIndicatorBackgroundKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedViewKeys.loadingIndicatorBackgroundKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setLoadingState(show: Bool) {
        if show, loadingIndicator == nil {
            
            let spinnerBackground = UIView()
            spinnerBackground.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            spinnerBackground.clipsToBounds = true
            spinnerBackground.layer.cornerRadius = 10
            
            let indicator = UIActivityIndicatorView(style: .gray)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.layer.zPosition = CGFloat(Int.max)
            indicator.color = .white
            
            spinnerBackground.addSubview(indicator)
            addSubview(spinnerBackground)
            bringSubviewToFront(spinnerBackground)
            indicator.snp.makeConstraints({$0.center.equalToSuperview()})
            indicator.layoutIfNeeded()
            indicator.startAnimating()
            
            spinnerBackground.snp.makeConstraints { make in
                        make.centerY.equalToSuperview()
                        make.centerX.equalToSuperview()
                        make.width.height.equalTo(indicator.frame.width*3)
            }
            
            loadingIndicator = indicator
            loadingSpinnerBackground = spinnerBackground
            
        } else if !show, loadingIndicator != nil {
            loadingIndicator!.removeFromSuperview()
            loadingIndicator = nil
            loadingSpinnerBackground?.removeFromSuperview()
            loadingSpinnerBackground = nil
        }
    }

    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            ***REMOVED*** xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.bindFrameToSuperviewBounds()
        return contentView
    }

    func bindFrameToSuperviewBounds(lefMargin: CGFloat? = nil, rightMargin: CGFloat? = nil, topMargin: CGFloat? = nil, bottomMargin: CGFloat? = nil) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        let lefMargin = lefMargin?.description ?? "0"
        let rightMargin = rightMargin?.description ?? "0"
        let topMargin = topMargin?.description ?? "0"
        let bottomMargin = bottomMargin?.description ?? "0"

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-" + lefMargin + "-[subview]-" + rightMargin + "-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-" + topMargin + "-[subview]-" + bottomMargin + "-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }

    ***REMOVED*** FIXME: yesclub shadow extension applySketchShadow
    func dropShadow() {
        self.clipsToBounds = false

        let whiteDropShadowLayer = CALayer()
        whiteDropShadowLayer.masksToBounds = false
        whiteDropShadowLayer.shadowColor = UIColor.init(red: 203/255, green: 203/255, blue: 203/255, alpha: 0.5).cgColor
        whiteDropShadowLayer.shadowOpacity = 1.0
        whiteDropShadowLayer.shadowOffset = CGSize(width: 0, height: -2)
        whiteDropShadowLayer.shadowRadius = 7.5
        whiteDropShadowLayer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.insertSublayer(whiteDropShadowLayer, at: 0)

        let blueShadowLayer = CALayer()
        blueShadowLayer.masksToBounds = false
        blueShadowLayer.shadowColor = UIColor.init(red: 38/255, green: 43/255, blue: 58/255, alpha: 1.0).cgColor
        blueShadowLayer.shadowOpacity = 0.5
        blueShadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        blueShadowLayer.shadowRadius = 3
        blueShadowLayer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.insertSublayer(blueShadowLayer, at: 0)
    }

}
