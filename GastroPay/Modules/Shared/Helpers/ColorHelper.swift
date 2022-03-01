***REMOVED***
***REMOVED***  ColorHelper.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 16.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public struct ColorHelper {
    public static let activeColor = Colors.everglade

    public struct General {
        public static let vcBackgroundColor = Colors.white
        public static let navigationBarTitleColor = UIColor(rgb: 0x273C2F)
    }

    public struct Walkthrough {
        public static let titleLabelText = Colors.celtic
        public static let descriptionLabelText = Colors.celtic

        public static let registerButtonBackground = Button.backgroundColor
        public static let registerButtonText = Button.textColor

        public static let loginButtonText = Button.textColor
        public static let test = Button.backgroundColor
    }

    public struct Login {
        public static let navigationTitle = Colors.everglade
        public static let welcomeHeader = Colors.everglade
        public static let welcomeHeaderInfo = Colors.everglade
        public static let loginButtonBackground = UIColor(r: 255, g: 202, b: 40)
        public static let loginButtonText = Colors.everglade
        public static let loginButtonDisabledBackground = UIColor(r: 236, g: 240, b: 241)
        public static let loginButtonDisabledText = UIColor(r: 59, g: 68, b: 78)
    }

    public struct Campaigns {
        public static let campaignRemainingTime = ColorHelper.Colors.sunglow
    }

    public struct CampaignDetail {
        public static let campaignsForYouText = Colors.white
        public static let titleText = Colors.white
    }

    public struct CampaignsHeader {
        public static let cardBackground = Colors.white
        public static let cardBackgroundRegister = Colors.everglade
    }

    public struct Tabbar {
        public static let textColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        public static let iconColor = UIColor(white: 227.0 / 255.0, alpha: 1.0)

        public static let highlightTextColor = Colors.sunglow
        public static let highlightIconColor = Colors.sunglow

        public static let backdropColor = UIColor(red: 39.0 / 255.0, green: 60.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
        public static let highlightBackdropColor = Colors.celtic
    }

    public struct Pager {
        public static let activePageIndicator = UIColor(red: 67.0 / 255.0, green: 140.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
        public static let indicator = Colors.celtic.withAlphaComponent(0.2)
    }

    public struct Button {
        public static let backgroundColor = UIColor(red: 255.0 / 255.0, green: 202.0 / 255.0, blue: 40.0 / 255.0, alpha: 1.0)
        public static let backgroundColorDisabled = UIColor(red: 218.0 / 255.0, green: 221.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)

        public static let textColor = UIColor(red: 38.0 / 255.0, green: 43.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
        public static let textColorDisabled = UIColor(red: 59.0 / 255.0, green: 68.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }

    public struct Text {
        public static let gray1 = UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }

    public struct Gradient {
        public struct HeaderGradient {
            public static let stop1 = UIColor.black
            public static let stop2 = UIColor.black.withAlphaComponent(0.4)
            public static let stop3 = UIColor.black.withAlphaComponent(0.0)
        }

        public struct UnitGradient {
            public static let stop1 = UIColor.black.withAlphaComponent(0.0)
            public static let stop2 = UIColor.black.withAlphaComponent(0.25)
            public static let stop3 = UIColor.black.withAlphaComponent(0.8)
        }
    }

    public struct PopupDialog {
        public static let titleText = Colors.celtic
        public static let bodyText = Colors.celtic
        public static let actionButtonText = Colors.celtic
    }

    public struct PaymentConfirmation {
        public static let backgroundColor = UIColor(rgb: 0xF8F8F8)
        public static let merchantTitle = Colors.celtic
        public static let merchantLocation = UIColor(r: 99, g: 172, b: 128)
        public static let paymentMethod = Colors.celtic
        public static let cardAlias = Colors.celtic
        public static let maskedCardNumber = Colors.celtic
        public static let changeCard = UIColor(r: 99, g: 172, b: 128)

        public static let summaryUsingYeTLInfoLabel = UIColor(rgb: 0xBDC3C7)
        public static let summaryYeTLLabel = Colors.everglade
        public static let summaryYeTLAmount = Colors.everglade
        public static let summaryOrderLabel = Colors.everglade
        public static let summaryOrderAmount = Colors.everglade
        public static let summarySpendingLabel = Colors.everglade
        public static let summarySpendingAmount = Colors.everglade
        public static let summaryTotalLabel = Colors.everglade
        public static let summaryTotalAmount = Colors.everglade

        public struct MerchantInfo {
            public static let priceToPayText = UIColor(red: 0.387, green: 0.674, blue: 0.502, alpha: 1)
            public static let priceText = UIColor.white
            public static let backgroundColor = UIColor(red: 0.153, green: 0.235, blue: 0.184, alpha: 1)
        }

        public struct SelectCard {
            public static let containerBackgroundColor = UIColor(rgb: 0xF8F8F8)
            public static let selectCardLabel = UIColor(rgb: 0x273C2F)
            public static let containerShadowColor = UIColor(r: 39, g: 69, b: 47, a: 0.2)
            public static let cardAliasText = UIColor.white
            public static let cardMaskedNumber = UIColor(rgb: 0xBDC3C7)
            public static let selectedCardLabelContainerBackground = UIColor(rgb: 0xFFCA28)
            public static let selectedCardLabelText = UIColor(rgb: 0x3B444E)
            public static let cellBackground = UIColor(rgb: 0x3B444E)
            public static let cellSelectedGradientStop0 = UIColor(r: 206, g: 173, b: 0)
            public static let cellSelectedGradientStop1 = UIColor(r: 113, g: 95, b: 0)
        }

        public struct ExpendableBalance {
            public static let containerBackgroundSpend = UIColor(red: 0.186, green: 0.292, blue: 0.228, alpha: 1.0)
            public static let containerBackground = UIColor.white
            public static let containerShadow = UIColor(red: 0.516, green: 0.516, blue: 0.516, alpha: 0.2)

            public static let expendableBalanceLabelTextSpend = UIColor.white
            public static let expendableBalanceLabelText = UIColor(rgb: 0x273C2F)
            public static let expendableBalanceTextSpend = UIColor(rgb: 0xFFCA28)
            public static let expendableBalanceText = UIColor(rgb: 0x273C2F)

            public static let spendButtonTextActive = UIColor(rgb: 0xFFCA28)
            public static let spendButtonText = UIColor(rgb: 0x273C2F)
            public static let spendButtonBorderActive = UIColor(rgb: 0xFFCA28)
            public static let spendButtonBorder = UIColor(rgb: 0x273C2F)
        }
    }

    public struct Tutorial {
        public static let itemTitle = UIColor.white
        public static let buttonActive = UIColor(hexString: "#FFCA28")
        public static let ringColor = UIColor(hexString: "#FFCA28")
    }

    public struct PaymentResult {
        public static let cardBackgroundColor = Colors.everglade
        public static let statusInfo = UIColor.white
        public static let amountLabel = UIColor.white
        public static let amount = UIColor.white
        public static let contactUsHeader = Colors.everglade
        public static let contactUsDesc = Colors.gray1
        public static let contactUsButton = Colors.everglade
    }

    public struct Pin {
        public static let header = UIColor.black
        public static let desc = UIColor(r: 127, g: 128, b: 128)
    }

    public struct OneTimePassword {
        public static let digitInputLabelText = UIColor(r: 128, g: 128, b: 128)
    }

    public struct YeTLDetail {
        public static let navigationBackground = Colors.everglade
        public static let priceColor = Colors.everglade
        public static let headerColor = UIColor(r: 128, g: 128, b: 128)
        public static let summaryTitle = UIColor(r: 3, g: 3, b: 3)
        public static let buttonTitle = Colors.everglade
        public static let buttonBackground = UIColor(r: 255, g: 202, b: 40)
    }

    public struct Restaurant {
        public struct Detail {
            public static let restaurantTitle = UIColor(r: 39, g: 60, b: 47)
            public static let tagBackground = UIColor(r: 236, g: 240, b: 241)
            public static let tagText = UIColor(r: 59, g: 68, b: 78)
            public static let lightText = UIColor(r: 81, g: 90, b: 100)
            public static let yemedenOlmazTitle = Colors.sunglow
            public static let layerColor = Colors.everglade
        }
    }

    public struct ContainerCell {
        public static let headerColor = UIColor(r: 39, g: 60, b: 47)
    }

    public struct Wallet {
        public static let containerBackgroundColor = UIColor(red: 0.972, green: 0.972, blue: 0.972, alpha: 1)
        public static let yetlDisabled = UIColor(r: 206, g: 206, b: 206)
        public static let yetlActive = Colors.everglade
        public static let yetlDetailButtonText = UIColor(rgb: 0x273C36)
        public static let yetlContainerShadowColor = UIColor(red: 0.516, green: 0.516, blue: 0.516, alpha: 0.25)
        public static let title = UIColor(r: 43, g: 46, b: 54)
        public static let noCardTitle = UIColor(hexString: "#030303")
        public static let noCardDescription = UIColor(hexString: "#404040")

        public struct Transaction {
            public static let backgroundColorForEvenCells = UIColor(r: 241, g: 255, b: 247)
            public static let backgroundColorForOddCells = UIColor.white

            public static let walletCellDepositTextColor = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)
            public static let walletCellWithdrawTextColor = UIColor(red: 0.993, green: 0.221, blue: 0.315, alpha: 1)
            public static let walletCellCancelTextColor = UIColor(red: 0.565, green: 0.565, blue: 0.565, alpha: 1)

            public static let walletCellDateTextColor = Colors.regentGray
            public static let walletCellAmountTextColor = Colors.black
            public static let walletCellMerchantName = Colors.black
            public static let transactionTitle = Colors.black
        }

        public struct TransactionDetail {
            public static let containerBackground = UIColor(red: 250 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1.0)
            public static let labelColor = UIColor(red: 87 / 255, green: 108 / 255, blue: 138 / 255, alpha: 1.0)
            public static let dataColor = UIColor(red: 44 / 255, green: 47 / 255, blue: 74 / 255, alpha: 1.0)
            public static let separatorColor = UIColor(red: 238 / 255, green: 241 / 255, blue: 247 / 255, alpha: 1.0)

            public static let transactionStatusCancel = UIColor(red: 0.565, green: 0.565, blue: 0.565, alpha: 1)
            public static let transactionStatusWithdraw = UIColor(red: 0.993, green: 0.221, blue: 0.315, alpha: 1)
            public static let transactionStatusDeposit = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)
        }

        public struct CreditCard {
            public static let cardIconContainerBGActive = Colors.black
        }

        public struct AddCard {
            public static let background = UIColor(r: 244, g: 244, b: 244)
            public static let pageControlSelected = UIColor(r: 46, g: 204, b: 113)
            public static let pageControlNotSelected = UIColor(r: 39, g: 60, b: 47, a: 0.2)
            public static let title = UIColor(r: 39, g: 60, b: 47)

            public struct Button {
                public static let backgroundActive = ColorHelper.Button.backgroundColor
                public static let backgroundDisabled = ColorHelper.Button.backgroundColorDisabled

                public static let textColor = Colors.everglade
                public static let disabledTextColor = UIColor(r: 59, g: 68, b: 78)
            }
        }
    }

    public struct Restaurants {
        public static let mapViewCellShadow = UIColor(red: 248.0 / 255.0, green: 248.0 / 255.0, blue: 248.0 / 255.0, alpha: 1)

        public struct MapView {
            public static let collectionCellTitle = Colors.everglade
            public static let collectionCellDesc = Colors.everglade
            public static let rewardString = Colors.everglade
        }
    }

    public struct RestaurantSearch {
        public static let tagPillBackground = UIColor.white
        public static let tagPillBackgroundSelected = UIColor(r: 255, g: 202, b: 41)

        public static let criteriaTitle = UIColor(red: 0.169, green: 0.18, blue: 0.212, alpha: 1)
        public static let criteriaItemTitle = UIColor(red: 0.169, green: 0.18, blue: 0.212, alpha: 1)
        
        public static let cityBorder = UIColor(red: 0.788, green: 0.808, blue: 0.796, alpha: 1)
        public static let cityTitle = UIColor(red: 0.153, green: 0.235, blue: 0.184, alpha: 1)
    }

    public struct Profile {
        public static let nameSurname = Colors.heavyMetal
        public static let email = Colors.silverSand
        public static let gsm = Colors.silverSand
        public static let contactUs = Colors.heavyMetal
        public static let howToUse = Colors.heavyMetal
        public static let faq = Colors.heavyMetal
        public static let cellTitles = Colors.heavyMetal
    }

    public struct Units {
        public static let title = UIColor(r: 43, g: 46, b: 54)

        public struct MerchantsClose {
            public static let title = Colors.white
            public static let distance = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)
        }

        public struct MerchantLists {
            public static let listTitle = UIColor.white
            public static let merchantCount = UIColor(red: 0.18, green: 0.8, blue: 0.443, alpha: 1)
        }

        public struct CreditCardCampaigns {
            public static let title = Colors.black
        }

        public struct SegmentedControl {
            public static let activeColor = UIColor(red: 255 / 255, green: 202 / 255, blue: 40 / 255, alpha: 1.0)
            public static let inactiveColor = UIColor.white
        }
    }

    public struct LocationPermissionWarning {
        public static let title = Colors.everglade
        public static let description = Colors.everglade
    }
}

private extension ColorHelper {
    private struct Colors {
        static let white = UIColor.white
        static let black = UIColor.black

        static let celtic = UIColor(r: 39, g: 69, b: 48)
        static let sunglow = UIColor(r: 255, g: 202, b: 40)
        static let everglade = UIColor(r: 39, g: 60, b: 47)
        static let aquaForest = UIColor(r: 99, g: 172, b: 128)

        ***REMOVED*** Green
        static let heavyMetal = UIColor(r: 38, g: 60, b: 47, a: 1.0)

        ***REMOVED*** Gray
        static let silverSand = UIColor(r: 189, g: 195, b: 199, a: 1.0)
        static let doveGray = UIColor(r: 111, g: 111, b: 111, a: 1.0)
        static let gray1 = UIColor(r: 144, g: 144, b: 144)
        static let regentGray = UIColor(r: 147, g: 157, b: 167)
    }
}

public extension UIColor {
    convenience init(r red: Int, g green: Int, b blue: Int, a alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    convenience init(rgb: Int) {
        self.init(
            r: (rgb >> 16) & 0xFF,
            g: (rgb >> 8) & 0xFF,
            b: rgb & 0xFF
        )
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: ***REMOVED*** RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: ***REMOVED*** RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: ***REMOVED*** ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
