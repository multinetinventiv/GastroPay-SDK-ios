***REMOVED***
***REMOVED***  PopupManager.swift
***REMOVED***  Alamofire
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***

import UIKit
import SwiftMessages

public protocol MIPopupView: UIView {
    var dialogId: String { get }

    func popupWillBeHidden()
}

public typealias MIMessageTheme = Theme

public protocol MIMessageView: UIView {
    
}

public extension MIPopupView {
    func popupWillBeHidden() { }
}

public class MIPopupManager {
    
    public static var activePopupId: String?
    
    public init() {}

    public func showWarningMessage() {
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()

        let iconText = ["🤔", "😳", "🙄", "😶"].randomElement()!
        warning.configureContent(title: "Warning", body: "Consider yourself warned.", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)

        SwiftMessages.show(config: warningConfig, view: warning)
    }

    public func showStatusLineMessage(theme: MIMessageTheme, drawShadow: Bool = true, title: String? = nil, body: String? = nil, iconImage: UIImage? = nil, iconText: String? = nil, buttonImage: UIImage? = nil, buttonTitle: String? = nil, buttonTapHandler: ((UIButton) -> Void)? = nil) {
        showMessage(theme: theme, layout: .statusLine, presentationContextLevel: .statusBar, drawShadow: drawShadow, title: title, body: body, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandler)
    }

    public func showCardMessage(theme: MIMessageTheme, drawShadow: Bool = true, title: String? = nil, body: String? = nil, iconImage: UIImage? = nil, iconText: String? = nil, buttonImage: UIImage? = nil, buttonTitle: String? = nil, buttonTapHandler: ((UIButton) -> Void)? = nil) {
        showMessage(theme: theme, layout: .cardView, presentationContextLevel: .statusBar, drawShadow: drawShadow, title: title, body: body, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandler)
    }

    public func showMessage(theme: MIMessageTheme, layout: MessageView.Layout, presentationContextLevel: UIWindow.Level = .statusBar, drawShadow: Bool = true, title: String? = nil, body: String? = nil, iconImage: UIImage? = nil, iconText: String? = nil, buttonImage: UIImage? = nil, buttonTitle: String? = nil, buttonTapHandler: ((UIButton) -> Void)? = nil) {
        let messageView = MessageView.viewFromNib(layout: layout)
        messageView.configureTheme(theme as! Theme)
        if drawShadow {
            messageView.configureDropShadow()
        }

        if buttonTitle == nil || buttonImage == nil {
            messageView.button?.isHidden = true
        }

        messageView.configureContent(title: title, body: body, iconImage: iconImage, iconText: iconText, buttonImage: buttonImage, buttonTitle: buttonTitle, buttonTapHandler: buttonTapHandler)
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: .alert)
        SwiftMessages.show(config: config, view: messageView)
        ***REMOVED***SwiftMessages.show(view: messageView)
    }

    public func showDialog(_ dialog: MIPopupView, leftInset: CGFloat = 16, rightInset: CGFloat = 16, bottom: CGFloat = 0, presentationStyle: SwiftMessages.PresentationStyle = .center, onlyRoundTop: Bool = false, viewController: UIViewController? = nil, removeDim:Bool = false) {
        let messageView = MessageView(frame: .zero)
        messageView.id = dialog.dialogId

        do {
            let backgroundView = CornerRoundingView()
            if !onlyRoundTop{
                backgroundView.cornerRadius = 15
            }
            else{
                backgroundView.layer.cornerRadius = 15
                if #available(iOS 11.0, *) {
                    backgroundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                } else {
                    ***REMOVED*** Fallback on earlier versions
                }
            }
            backgroundView.layer.masksToBounds = true
            messageView.installBackgroundView(backgroundView, insets: UIEdgeInsets(top: 0, left: leftInset, bottom: bottom, right: rightInset))
            messageView.installContentView(dialog)
        }
        messageView.configureDropShadow()

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = presentationStyle
        config.duration = .forever

        config.dimMode = removeDim ? .none : .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        
        config.presentationContext = viewController != nil ? .viewController(viewController!) : .window(windowLevel: .statusBar)

        config.eventListeners.append() { event in
            if case .willHide = event { dialog.popupWillBeHidden() }
        }

        messageView.layoutIfNeeded()
        SwiftMessages.show(config: config, view: messageView)
    }

    public func hideDialog(_ dialog: MIPopupView) {
        SwiftMessages.hide(id: dialog.dialogId)
    }

    public func hideDialog(id: String) {
        SwiftMessages.hide(id: id)
    }

}
