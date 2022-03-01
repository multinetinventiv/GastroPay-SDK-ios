***REMOVED***
***REMOVED***  PayWithQRView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import Foundation
import UIKit

class PayWithQRView: UIView {
    let cameraView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let cameraOverlay = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let navigationTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(vc: MIViewController) {
        addSubview(cameraView)
        cameraView.bindFrameToSuperviewBounds()
        
        addSubview(cameraOverlay)
        cameraOverlay.bindFrameToSuperviewBounds()

        let seeThroughRectWidth = vc.view.bounds.size.width * 280 / 380
        let seeThroughRectHeight = vc.view.bounds.size.height * 370 / 670

        let backgroundGrayLayer = CAShapeLayer()
        let backgroundGrayLayerPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: vc.view.bounds.size.width, height: vc.view.bounds.size.height))
        backgroundGrayLayerPath.append(UIBezierPath(rect: CGRect(x: (vc.view.bounds.size.width - seeThroughRectWidth) / 2, y: (vc.view.bounds.size.height - seeThroughRectHeight) / 2, width: seeThroughRectWidth, height: seeThroughRectHeight)))
        backgroundGrayLayer.path = backgroundGrayLayerPath.cgPath
        backgroundGrayLayer.fillRule = .evenOdd
        backgroundGrayLayer.fillColor = UIColor.black.cgColor
        backgroundGrayLayer.opacity = 0.5
        cameraOverlay.layer.addSublayer(backgroundGrayLayer)

        let cornerBorderColor = UIColor(red: 255 / 255, green: 202 / 255, blue: 40 / 255, alpha: 1.0).cgColor

        let borderTopLeftVertical = CALayer()
        borderTopLeftVertical.backgroundColor = cornerBorderColor
        borderTopLeftVertical.frame = CGRect(x: (vc.view.bounds.size.width - seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height - seeThroughRectHeight) / 2 - 3, width: 6, height: 53)
        cameraOverlay.layer.addSublayer(borderTopLeftVertical)

        let borderTopLeftHorizontal = CALayer()
        borderTopLeftHorizontal.backgroundColor = cornerBorderColor
        borderTopLeftHorizontal.frame = CGRect(x: (vc.view.bounds.size.width - seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height - seeThroughRectHeight) / 2 - 3, width: 53, height: 6)
        cameraOverlay.layer.addSublayer(borderTopLeftHorizontal)

        let borderTopRightVertical = CALayer()
        borderTopRightVertical.backgroundColor = cornerBorderColor
        borderTopRightVertical.frame = CGRect(x: (vc.view.bounds.size.width + seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height - seeThroughRectHeight) / 2 - 3, width: 6, height: 53)
        cameraOverlay.layer.addSublayer(borderTopRightVertical)

        let borderTopRightHorizontal = CALayer()
        borderTopRightHorizontal.backgroundColor = cornerBorderColor
        borderTopRightHorizontal.frame = CGRect(x: (vc.view.bounds.size.width + seeThroughRectWidth) / 2 - 53, y: (vc.view.bounds.size.height - seeThroughRectHeight) / 2 - 3, width: 53, height: 6)
        cameraOverlay.layer.addSublayer(borderTopRightHorizontal)

        let borderBottomLeftVertical = CALayer()
        borderBottomLeftVertical.backgroundColor = cornerBorderColor
        borderBottomLeftVertical.frame = CGRect(x: (vc.view.bounds.size.width - seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height + seeThroughRectHeight) / 2 - 53, width: 6, height: 53)
        cameraOverlay.layer.addSublayer(borderBottomLeftVertical)

        let borderBottomLeftHorizontal = CALayer()
        borderBottomLeftHorizontal.backgroundColor = cornerBorderColor
        borderBottomLeftHorizontal.frame = CGRect(x: (vc.view.bounds.size.width - seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height + seeThroughRectHeight) / 2 - 3, width: 53, height: 6)
        cameraOverlay.layer.addSublayer(borderBottomLeftHorizontal)

        let borderBottomRightVertical = CALayer()
        borderBottomRightVertical.backgroundColor = cornerBorderColor
        borderBottomRightVertical.frame = CGRect(x: (vc.view.bounds.size.width + seeThroughRectWidth) / 2 - 3, y: (vc.view.bounds.size.height + seeThroughRectHeight) / 2 - 50, width: 6, height: 53)
        cameraOverlay.layer.addSublayer(borderBottomRightVertical)

        let borderBottomRightHorizontal = CALayer()
        borderBottomRightHorizontal.backgroundColor = cornerBorderColor
        borderBottomRightHorizontal.frame = CGRect(x: (vc.view.bounds.size.width + seeThroughRectWidth) / 2 - 50, y: (vc.view.bounds.size.height + seeThroughRectHeight) / 2 - 3, width: 53, height: 6)
        cameraOverlay.layer.addSublayer(borderBottomRightHorizontal)
    }
}
