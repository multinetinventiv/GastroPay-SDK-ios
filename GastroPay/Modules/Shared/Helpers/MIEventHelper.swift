***REMOVED***
***REMOVED***  MIEventHelper.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 17.03.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import Foundation


public struct MIEventHelper {
    public static let ShowAddCardPopup = "ShowAddCardPopup"
    public static let StartPaymentFlow = "StartPaymentFlow"
    public static let PaymentCompleted = "PaymentCompleted"
    public static let RestaurantFilterAction = "RestaurantFilterAction"
    public static let RefreshRestaurantLists = "RefreshRestaurantLists"
    public static let OpenCampaignDetail = "OpenCampaignDetail"
    public static let OpenCampaignView = "OpenCampaignView"
    public static let NewCardAdded = "NewCardAdded"
    public static let NotificationStatusChanged = "NotificationStatusChanged"
    public static let OpenProfile = "OpenProfile"
    public static let CreditCardsUpdated = "CreditCardsUpdated"
    public static let NotificationReceived = "NotificationReceived"
    public static let DeepLinkEventReceived = "DeepLinkEventReceived"
    public static let StartPaymentConfirmation = "StartPaymentConfirmation"
    public static let ErrorOccuredWhenPayWithCode = "ErrorOccuredWhenPayWithCode"
    public static let UserDataReceived = "UserDataReceived"
    
    public static func openCampaignDetail(_ campaign: Campaign) {
        MIServiceBus.post(MIEventHelper.OpenCampaignDetail, userInfo: ["campaign": campaign])
    }
    
    public static func openProfile() {
        MIServiceBus.post(MIEventHelper.OpenProfile)
    }
}
