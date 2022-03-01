***REMOVED***
***REMOVED***  FontHelper.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 23.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Foundation
import UIKit

public struct FontHelper {
    
    public struct Navigation {
        public static let title = FontHelper.semiBoldTextFont(size: 17)
    }

    public struct Walkthrough {
        public static let titleLabel = FontHelper.regularTextFont(size: 22)
        public static let descriptionLabel = FontHelper.regularTextFont(size: 18)
        public static let registerButton = FontHelper.semiBoldTextFont(size: 17)
        public static let loginButton = FontHelper.regularTextFont(size: 16)
    }

    public struct Restaurants {
        public struct SegmentedControl {
            public static let title = FontHelper.regularTextFont(size: 15)
        }

        public static let headerLabelClose = FontHelper.lightTextFont(size: 16)

        public struct Search {
            public static let criteriaTitle = FontHelper.mediumTextFont(size: 16)
            public static let criteriaItemTitle = FontHelper.regularTextFont(size: 14)
            public static let tagTitle = FontHelper.regularTextFont(size: 12)
            public static let cityTagTitle = FontHelper.lightTextFont(size: 13)
        }

        public struct Detail {
            public static let earn = FontHelper.semiBoldTextFont(size: 17)
            public static let restaurantName = FontHelper.mediumTextFont(size: 30)
            public static let restaurantLocation = FontHelper.regularTextFont(size: 17)
            public static let tag = FontHelper.regularTextFont(size: 14)
            public static let textContent = FontHelper.lightTextFont(size: 16)
            public static let mapContent = FontHelper.regularTextFont(size: 17)
            public static let yemedenOlmazDesc = FontHelper.mediumTextFont(size: 16)
            public static let campaignTitle = FontHelper.mediumTextFont(size: 13)
            public static let mealTitle = FontHelper.mediumTextFont(size: 28)
            public static let mealDescription = FontHelper.lightTextFont(size: 17)
            public static let mealContainerTitle = FontHelper.regularTextFont(size: 14)
        }

        public struct MapView {
            public static let cellTitle = FontHelper.mediumTextFont(size: 18)
            public static let cellDistance = FontHelper.regularTextFont(size: 12)
        }
    }

    public struct Container {
        public static let header = FontHelper.regularTextFont(size: 19)
        public static let navigationButton = FontHelper.semiBoldTextFont(size: 18)
    }

    public struct Campaigns {
        public static let navigationTitle = FontHelper.boldTextFont(size: 17)
        public static let campaignRemainingTime = FontHelper.regularTextFont(size: 12)
        public static let campaignTitle = FontHelper.regularTextFont(size: 17)
    }

    public struct CampaignDetail {
        public static let campaignsForYou = FontHelper.regularTextFont(size: 13)
        public static let title = FontHelper.mediumTextFont(size: 26)
        public static let description = FontHelper.regularTextFont(size: 14)
    }

    public struct Register {
        public static let welcomeHeader = FontHelper.mediumTextFont(size: 28)
        public static let welcomeInfo = FontHelper.lightTextFont(size: 14)
        public static let consentLabels = FontHelper.mediumTextFont(size: 12)
    }

    public struct Login {
        public static let navigationTitle = FontHelper.semiBoldTextFont(size: 17)
        public static let welcomeHeader = FontHelper.mediumTextFont(size: 32)
        public static let welcomeHeaderInfo = FontHelper.lightTextFont(size: 18)
        public static let loginButton = FontHelper.semiBoldTextFont(size: 22)
    }

    public struct OneTimePassword {
        public static let digitInputLabel = FontHelper.lightTextFont(size: 13)
        public static let welcomeHeader = FontHelper.mediumTextFont(size: 28)
        public static let welcomeInfo = FontHelper.lightTextFont(size: 14)
        public static let countLabel = FontHelper.lightTextFont(size: 14)
        public static let sendAgainButton = FontHelper.semiBoldTextFont(size: 17)
    }

    public struct DiscountView {
        public static let percentSign = FontHelper.heavyTextFont(size: 10)
        public static let percentLabel = FontHelper.heavyTextFont(size: 18)
    }

    public struct PaymentConfirmation {
        public static let merchantTitle = FontHelper.semiBoldTextFont(size: 20)
        public static let merchantLocation = FontHelper.semiBoldTextFont(size: 13)
        public static let paymentMethod = FontHelper.mediumTextFont(size: 17)
        public static let cardAlias = FontHelper.boldTextFont(size: 14)
        public static let maskedCardNumber = FontHelper.boldTextFont(size: 11)
        public static let changeCard = FontHelper.regularTextFont(size: 15)

        public static let summaryYeTLLabel = FontHelper.regularTextFont(size: 17)
        public static let summaryYeTLAmount = FontHelper.regularTextFont(size: 17)
        public static let summaryOrderLabel = FontHelper.regularTextFont(size: 17)
        public static let summaryOrderAmount = FontHelper.regularTextFont(size: 17)
        public static let summarySpendingLabel = FontHelper.regularTextFont(size: 17)
        public static let summarySpendingAmount = FontHelper.semiBoldTextFont(size: 17)
        public static let summaryTotalLabel = FontHelper.semiBoldTextFont(size: 17)
        public static let summaryTotalAmount = FontHelper.semiBoldTextFont(size: 17)

        public static let payButton = FontHelper.semiBoldTextFont(size: 17)

        public struct Result {
            public static let endButton = FontHelper.semiBoldTextFont(size: 17)
        }

        public struct MerchantInfo {
            public static let priceToPayLabel = FontHelper.semiBoldTextFont(size: 13)
            public static let priceToPayValue = FontHelper.boldTextFont(size: 34)
        }

        public struct PaymentInfo {
            public static let earningInfoLabel = FontHelper.regularTextFont(size: 18)
            public static let earningInfoValue = FontHelper.regularTextFont(size: 18)
            public static let earningUsingInfoLabel = FontHelper.regularTextFont(size: 14)
            public static let orderInfoLabel = FontHelper.regularTextFont(size: 18)
            public static let orderInfoValue = FontHelper.regularTextFont(size: 18)
            public static let spendingInfoLabel = FontHelper.regularTextFont(size: 18)
            public static let spendingInfoValue = FontHelper.semiBoldTextFont(size: 18)
            public static let totalInfoLabel = FontHelper.semiBoldTextFont(size: 18)
            public static let totalInfoValue = FontHelper.semiBoldTextFont(size: 18)
        }

        public struct SelectCard {
            public static let selectCardLabel = FontHelper.regularTextFont(size: 20)
            public static let cardAlias = FontHelper.regularTextFont(size: 12)
            public static let cardMaskedNumber = FontHelper.regularTextFont(size: 13)
            public static let selectedCardLabel = FontHelper.regularTextFont(size: 14)
        }

        public struct ExpendableBalance {
            public static let expendableLabelFont = FontHelper.regularTextFont(size: 14)
            public static let expendableValueFont = FontHelper.mediumTextFont(size: 18)
            public static let spendButtonTitle = FontHelper.semiBoldTextFont(size: 17)
        }
    }

    public struct Tutorial {
        public static let itemTitle = FontHelper.regularTextFont(size: 20)
        public static let buttonTitle = FontHelper.semiBoldTextFont(size: 18)
    }

    public struct PaymentResult {
        public static let statusInfo = FontHelper.boldTextFont(size: 20)
        public static let amountLabel = FontHelper.regularTextFont(size: 17)
        public static let amount = FontHelper.boldTextFont(size: 34)
        public static let contactUsHeader = FontHelper.regularTextFont(size: 19)
        public static let contactUsDesc = FontHelper.boldTextFont(size: 16)
        public static let contactUsButton = FontHelper.semiBoldTextFont(size: 19)
    }

    public struct PopupDialog {
        public static let title = FontHelper.mediumTextFont(size: 18)
        public static let body = FontHelper.regularTextFont(size: 16)
        public static let actionButton = FontHelper.semiBoldTextFont(size: 20)
    }

    public struct Pin {
        public static let header = FontHelper.semiBoldTextFont(size: 18)
        public static let desc = FontHelper.regularTextFont(size: 16)
    }

    public struct YeTL {
        public static let price = FontHelper.boldTextFont(size: 24)
        public static let priceAttribute = FontHelper.boldTextFont(size: 14)
        public static let description = FontHelper.mediumTextFont(size: 13)
        public static let headerTitle = FontHelper.mediumTextFont(size: 13)
        public static let expenseMonth = FontHelper.mediumTextFont(size: 12)
        public static let summaryDescription = FontHelper.mediumTextFont(size: 18)
        public static let summaryButton = FontHelper.semiBoldTextFont(size: 17)
    }

    public struct Wallet {
        public static let yetlNumber = FontHelper.boldTextFont(size: 32)
        public static let yetlLabel = FontHelper.semiBoldTextFont(size: 14)
        public static let yetlAmountLabel = FontHelper.lightTextFont(size: 14)
        public static let yetlDetailButton = FontHelper.semiBoldTextFont(size: 17)
        public static let expendableBalance = FontHelper.semiBoldTextFont(size: 14)
        public static let viewTitle = FontHelper.lightTextFont(size: 16)
        public static let cardAlias = FontHelper.semiBoldTextFont(size: 17)
        public static let cardNumber = FontHelper.lightTextFont(size: 13)
        public static let defaultCard = FontHelper.lightTextFont(size: 13)
        public static let transactionTitle = FontHelper.regularTextFont(size: 14)
        public static let transactionAmount = FontHelper.mediumTextFont(size: 17)
        public static let transactionExtraInfo = FontHelper.regularTextFont(size: 12)
        public static let noCardTitle = FontHelper.mediumTextFont(size: 17)
        public static let noCardDescription = FontHelper.lightTextFont(size: 16)

        public struct PuanDetail {
            public static let puanValue = FontHelper.boldTextFont(size: 32)
            public static let puanCurrency = FontHelper.semiBoldTextFont(size: 14)
            public static let puanBottomText = FontHelper.regularTextFont(size: 17)
        }

        public struct TransactionDetail {
            public static let rowLabel = FontHelper.mediumTextFont(size: 14)
            public static let rowValue = FontHelper.mediumTextFont(size: 14)
        }

        public struct AddCard {
            public static let input = FontHelper.lightTextFont(size: 15)
            public static let title = FontHelper.boldTextFont(size: 17)
            public static let buttonText = FontHelper.semiBoldTextFont(size: 17)
        }

        public struct Modal {
            public static let title = FontHelper.mediumTextFont(size: 17)
            public static let description = FontHelper.regularTextFont(size: 13)
        }
    }

    public struct Units {
        public static let title = FontHelper.regularTextFont(size: 18)

        public struct MerchantsClose {
            public static let locationPermissionTitle = FontHelper.mediumTextFont(size: 17)
            public static let locationPermissionDescription = FontHelper.regularTextFont(size: 15)

            public static let merchantTitle = FontHelper.mediumTextFont(size: 17)
            public static let merchantDistance = FontHelper.regularTextFont(size: 10)
        }

        public struct CreditCardCampaigns {
            public static let title = FontHelper.regularTextFont(size: 16)
        }

        public struct MerchantLists {
            public static let title = FontHelper.regularTextFont(size: 16)
            public static let merchantCount = FontHelper.regularTextFont(size: 14)
        }
    }

    public struct Profile {
        public static let nameSurname = FontHelper.semiBoldTextFont(size: 14)
        public static let email = FontHelper.lightTextFont(size: 13)
        public static let gsm = FontHelper.lightTextFont(size: 13)
        public static let contactUs = FontHelper.boldTextFont(size: 14)
        public static let howToUse = FontHelper.boldTextFont(size: 14)
        public static let faq = FontHelper.boldTextFont(size: 14)
        public static let cellTitles = FontHelper.mediumTextFont(size: 14)
    }

    public static let discountLabel = FontHelper.regularTextFont(size: 14)
}

public extension FontHelper {
    struct FontNames {
        struct Text {
            static let regular = "SFProText-Regular"
            static let medium = "SFProText-Medium"
            static let bold = "SFProText-Bold"
            static let semibold = "SFProText-Semibold"
            static let light = "SFProText-Light"
            static let heavy = "SFProText-Heavy"
        }
    }

    static func lightTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.light, size: size)!
    }

    static func heavyTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.heavy, size: size)!
    }

    static func regularTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.regular, size: size)!
    }

    static func mediumTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.medium, size: size)!
    }

    static func semiBoldTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.semibold, size: size)!
    }

    static func boldTextFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.Text.bold, size: size)!
    }

    static func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            let names = UIFont.fontNames(forFamilyName: familyName)
            for name in names {
                Service.getLogger()?.debug("FontFamilyName: \(familyName) FontName: \(name)")
            }
        }
    }

    static func registerAllFonts() {
        let fontFileNames = [
            "SF-Pro-Text-Bold", "SF-Pro-Text-Heavy", "SF-Pro-Text-Light", "SF-Pro-Text-Medium", "SF-Pro-Text-Regular", "SF-Pro-Text-Semibold"
        ]
        
        let bundle = BundleManager.getPodBundle()
        let fontExtension = "otf"
        fontFileNames.forEach { (font) in
            _ = UIFont.registerFont(bundle: bundle, fontName: font, fontExtension: fontExtension)
        }

        /*
        for fontFileName in fontFileNames {
            let bundle = Bundle(identifier: "com.multinetinventiv.gastropay.Shared")
            let pathForResourceString = bundle?.path(forResource: fontFileName, ofType: nil)
            let fontData = NSData(contentsOfFile: pathForResourceString!)
            let dataProvider = CGDataProvider(data: fontData!)
            let fontRef = CGFont(dataProvider!)!
            var errorRef: Unmanaged<CFError>?

            if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
                Service.getLogger().debug("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
        }
        */
    }
}
