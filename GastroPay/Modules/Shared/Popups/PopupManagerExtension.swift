***REMOVED***
***REMOVED***  PopupManagerExtensions.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 25.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Foundation


enum GastroPayPopupIds: String {
    case addCard = "addCardPopupDialog"
    case cameraNotAuthorized = "cameraAuthorizationPopupDialog"
    case yetlRequiredAmount = "yetlRequiredAmountPopupDialog"
    case addCardErrorState = "addCardErrorPopupDialog"
    case addCardSuccessState = "addCardSuccessPopupDialog"
    case locationAuthorization = "locationAuthorizationPopup"
    case puanEarned = "puanEarned"
    case payWithCode = "payWithCode"
}

public extension MIPopupManager {
    func showErrorMessage(_ error: Error) {
        self.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
    }

    func openAddCardPopup(actionCallback: (() -> Void)? = nil) {
        let popupView = AddCardPopupView(dialogId: GastroPayPopupIds.addCard.rawValue)
        popupView.titleLabel.text = Localization.Popups.registerAddCardTitle.local
        popupView.bodyLabel.text = Localization.Popups.registerAddCardBody.local
        if let actionCallback = actionCallback {
            popupView.actionCallback = actionCallback
        }
        showDialog(popupView)
    }

    func openPuanEarnedPopup(amount: String) {
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.puanEarned.rawValue)
        popupView.artwork.image = ImageHelper.PopupArtworks.puanEarned
        ***REMOVED***popupView.bodyLabel.text = Localization.Popups.puanEarnedBody.local.replacingOccurrences(of: "%1$s", with: String(format: "%.2f", amount))
        var bodyLabel = Localization.Popups.puanEarnedBody.local
        let amountTemp = amount
        if amountTemp.lowercased().contains("puan") && bodyLabel.lowercased().contains("puan"){
            bodyLabel = bodyLabel.replacingOccurrences(of: "puan", with: "")
        }
        popupView.bodyLabel.text = bodyLabel.replacingOccurrences(of: "%1$s", with: amountTemp)
        popupView.actionButton.setTitle(Localization.Popups.puanEarnedButtonText.local, for: .normal)
        popupView.actionCallback = {
            Service.getTabbarController()?.selectedIndex = 4
        }
        showDialog(popupView)
    }

    func openCameraAuthorizationPopup() {
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.cameraNotAuthorized.rawValue)
        popupView.artwork.image = ImageHelper.PopupArtworks.cameraAuthorization
        popupView.bodyLabel.text = Localization.Popups.cameraPermissionBody.local
        popupView.actionButton.setTitle(Localization.Popups.cameraPermissionButton.local, for: .normal)
        popupView.actionCallback = {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        showDialog(popupView)
    }

    func openLocationAuthorizationDeniedPopup() {
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.locationAuthorization.rawValue)
        popupView.artwork.image = ImageHelper.PopupArtworks.locationDenied
        popupView.bodyLabel.text = Localization.Popups.locationPermissionBody.local
        popupView.actionButton.setTitle(Localization.Popups.locationPermissionButton.local, for: .normal)
        popupView.actionCallback = {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        showDialog(popupView)
    }

    func openAddCardErrorPopup() {
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.cameraNotAuthorized.rawValue, title: Localization.Popups.addCardErrorTitle.local)
        popupView.artwork.image = ImageHelper.PopupArtworks.addCardError
        popupView.bodyLabel.text = Localization.Popups.addCardErrorBody.local
        popupView.actionButton.setTitle(Localization.Popups.addCardErrorButton.local, for: UIControl.State.normal)
        showDialog(popupView)
    }

    func openAddCardSuccessPopup(actionCallback: (() -> Void)? = nil, willHideCallback: (() -> Void)? = nil) {
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.cameraNotAuthorized.rawValue, title: Localization.Popups.addCardSuccessBody.local)
        popupView.artwork.image = ImageHelper.PopupArtworks.addCardSuccess
        popupView.actionButton.setTitle(Localization.Popups.addCardSuccessButton.local, for: UIControl.State.normal)
        popupView.actionCallback = {
            self.hideDialog(popupView)
            if let callback = actionCallback {
                callback()
            }
        }
        popupView.willHideCallback = willHideCallback
        showDialog(popupView)
    }

    func openYeTLRequiredAmountPopup(requiredBalance: String, blockedBalance: String) {
        let title = Localization.Popups.walletYetlRequiredTitle.local.replacingOccurrences(of: "%1$s", with: requiredBalance)
        let popupView = DefaultPopupDialogView(dialogId: GastroPayPopupIds.yetlRequiredAmount.rawValue, title: title)
        popupView.artwork.image = ImageHelper.PopupArtworks.puanRequired
        popupView.bodyLabel.text = Localization.Popups.walletYetlRequiredBody.local.replacingOccurrences(of: "%1$s", with: blockedBalance)
        popupView.actionButton.setTitle(Localization.Popups.walletYetlRequiredButton.local, for: .normal)
        popupView.actionCallback = { self.hideDialog(id: popupView.dialogId) }
        showDialog(popupView)
    }
    
    func hideActiveDialog(){
        if let popupId = MIPopupManager.activePopupId{
            self.hideDialog(id: popupId)
        }
    }
}
