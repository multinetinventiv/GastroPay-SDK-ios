//
//  ImageHelper.swift
//  Shared
//
//  Created by  on 13.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit

public struct ImageHelper {
    public struct General {
        public static let woman = getImage(for: "woman")
        public static let logo = getImage(for: "logo")

        public static let merchantSavingBackground = getImage(for: "merchant_saving_background")
        public static let listsPlaceCountIcon = getImage(for: "icon_knife_fork")
        public static let listsBackground = getImage(for: "lists_background")

        public static let requestLocationIcon = getImage(for: "home_request_location_icon")
        public static let dropDownIcon = getImage(for: "chevron_down")
    }

    public struct Icons {
        public static let search = getImage(for: "icon_search")
        public static let search_green = getImage(for: "icon_search_green")
        public static let close = getImage(for: "icon_close")
        public static let open_map = getImage(for: "icon_open_map")
        public static let time = getImage(for: "icon_time")
        public static let puanText = getImage(for: "puan_text")
        public static let backArrow = getImage(for: "icon_back_arrow").tinted(with: .black)
        public static let cardYellow = getImage(for: "icon_card_yellow")
        public static let tick = getImage(for: "icon_tick")
        public static let cardSkewed = getImage(for: "icon_card_skewed")
        public static let user = getImage(for: "icon_user")
        public static let info = getImage(for: "icon_info")
        public static let tripleDot = getImage(for: "icon_triple_dot")
        public static let chevronRight = getImage(for: "icon_chevron_right")
        public static let share = getImage(for: "icon_share")
        public static let map_near_me = getImage(for: "map_near_me")
        public static let mapPin = getImage(for: "mapPin")
        public static let camera = getImage(for: "icon_camera")
        public static let puanGreen = getImage(for: "icon_puan_green")
        public static let puanYellow = getImage(for: "icon_puan_yellow")
        public static let phone = getImage(for: "icon_phone")
        public static let tickWithoutBorder = getImage(for: "icon_tick_without_border")
    }

    public struct Splash {
        public static let background = getImage(for: "splash_background")
    }

    public struct TabbarIcons {
        public static let home = getImage(for: "tabbar_icon_home")
        public static let restaurants = getImage(for: "tabbar_icon_restaurants")
        public static let pay = getImage(for: "tabbar_icon_pay")
        public static let payWhite = getImage(for: "tabbar_icon_pay_white")
        public static let campaigns = getImage(for: "tabbar_icon_campaigns")
        public static let wallet = getImage(for: "tabbar_icon_wallet")
    }

    public struct Walkthrough {
        public static let background1 = getImage(for: "walkthrough_image_1")
        public static let background2 = getImage(for: "walkthrough_image_2")
        public static let background3 = getImage(for: "walkthrough_image_3")
    }

    public struct Home {
        public static let gastroPayLogo = getImage(for: "logo")
    }

    public struct Tutorial {
        public static let artworkHome = getImage(for: "tutorial_art_home")
        public static let artworkRestaurants = getImage(for: "tutorial_art_restaurants")
        public static let artworkCampaigns = getImage(for: "tutorial_art_campaigns")
        public static let artworkWallet = getImage(for: "tutorial_art_wallet")
    }

    public struct PopupArtworks {
        public static let addCard = getImage(for: "artwork_add_credit_card")
        public static let cameraAuthorization = getImage(for: "artwork_camera")
        public static let puanRequired = getImage(for: "artwork_puan_required")
        public static let addCardError = getImage(for: "artwork_add_card_error")
        public static let addCardSuccess = getImage(for: "artwork_add_card_success")
        public static let locationDenied = getImage(for: "artwork_location_authorization_denied")
        public static let puanEarned = getImage(for: "artwork_puan_earned")
        public static let line = getImage(for: "Line")
    }

    public struct Wallet {
        public static let headerPuanIcon = getImage(for: "wallet_puan_header_icon")
        public static let headerPuanIconDark = getImage(for: "wallet_puan_header_icon_dark")
        public static let noCardArtwork = getImage(for: "wallet_no_card_artwork")
    }

    public struct YeTLDetail {
        public static let close = getImage(for: "icon_close")
        public static let coinLeft = getImage(for: "coin_left")
        public static let coinRight = getImage(for: "coin_right")
    }

    public struct RestaurantDetail {
        public static let defaultRestaurant = getImage(for: "merchant_saving_background")
        public static let map = getImage(for: "map_background")
        public static let coffee = getImage(for: "coffee_background")
        public static let expensivityEnabled = getImage(for: "expensivity_enabled")
        public static let expensivityDisabled = getImage(for: "expensivity_disabled")
        public static let campaignContent = getImage(for: "campaign_content")
        public static let mealBackground = getImage(for: "meal_background")
        public static let starbucksTemplate = getImage(for: "starbucks_icon")
        public static let locationPin = getImage(for: "location_pin")
        public static let yemedenOlmazText = getImage(for: "yemeden_olmaz_text")
    }

    public struct Profile {
        public static let changePin = getImage(for: "icon_profile_change_pin")
        public static let contactUs = getImage(for: "icon_profile_contact_us")
        public static let faq = getImage(for: "icon_profile_faq")
        public static let howToUse = getImage(for: "icon_profile_how_to_use")
        public static let logout = getImage(for: "icon_profile_logout")
        public static let person = getImage(for: "icon_profile_person")
        public static let invite = getImage(for: "icon_profile_invite")
        public static let settings = getImage(for: "icon_profile_settings")
        public static let takePhoto = getImage(for: "icon_profile_take_photo")
        public static let userAgreement = getImage(for: "icon_profile_user_agreement")
        public static let writeUs = getImage(for: "icon_profile_write_us")
        public static let emptyPhoto = getImage(for: "icon_profile_empty_photo")
        public static let backgroundImage = getImage(for: "profile_background_image_view")
        public static let whatsapp = getImage(for: "icon_profile_whatsapp")
        public static let contactUsBackground = getImage(for: "profile_contact_us_background")
        public static let settingsBackground = getImage(for: "profile_settings_background")
    }
    
    public struct Invite {
        
        public static let middleImage = getImage(for: "Invite_Center_Image")
        
        public static let grayBck = getImage(for: "grayBck")
        
        public static let share = getImage(for: "shareIcon")
    }
}

extension ImageHelper {
    private static func getImage(for name: String) -> UIImage {
        let bundle = BundleManager.getPodBundle()

        return UIImage(named: name, in: bundle, compatibleWith: nil) ?? UIImage()
    }
}
