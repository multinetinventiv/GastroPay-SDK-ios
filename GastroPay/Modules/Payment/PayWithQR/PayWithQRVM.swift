***REMOVED***
***REMOVED***  PayWithQRVM.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import Foundation

class PayWithQRVM {
    public var payWithQRView: PayWithQRView = PayWithQRView()
    public var navigationRightImage = ImageHelper.Icons.close
    public var navigationTitle = Localization.Payment.qrNavigationTitle.local
    public var navigationTitleFont = FontHelper.Login.navigationTitle
    public var navigationTitleTextColor = UIColor.white

    public func setupView(vc: MIViewController) {
        payWithQRView.navigationTitleLabel.text = self.navigationTitle
        payWithQRView.navigationTitleLabel.font = self.navigationTitleFont
        payWithQRView.navigationTitleLabel.textColor = self.navigationTitleTextColor
        
        vc.view.addSubview(self.payWithQRView)
        payWithQRView.bindFrameToSuperviewBounds()
        
        payWithQRView.setupView(vc: vc)
    }
}
