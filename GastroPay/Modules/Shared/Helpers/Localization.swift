***REMOVED***
***REMOVED***  Localization.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 23.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import Foundation

public struct Localization {
    
    public struct Forceupdate {
        public static let launchForceUpdateTitle = "force_update_title"
        public static let launchForceUpdateText = "force_update_body"
        public static let launchForceUpdateButton = "force_update_button"
    }
    
    public struct Walkthrough {
        public static let Title1 = "walkthrough_title_1"
        public static let Description1 = "walkthrough_description_1"
        public static let Title2 = "walkthrough_title_2"
        public static let Description2 = "walkthrough_description_2"
        public static let Title3 = "walkthrough_title_3"
        public static let Description3 = "walkthrough_description_3"

        public static let RegisterButton = "walkthrough_register"
        public static let LoginButton = "walkthrough_login"
    }

    public struct Restaurants {
        public static let navigationTitle = "restaurants_nav_title"
        public static let tabEarn = "restaurants_tab_earn"
        public static let tabSpend = "restaurants_tab_spend"
        public static let labelNear = "merchants_near_me_gastropay_sdk"

        public static let filterButton = "search_merchant_button_filter_gastropay_sdk"
        public static let clearFilterButton = "search_merchant_button_clear_filter_gastropay_sdk"
        public static let searchLocationButton = "restaurants_map__button_search_this_area"
        public static let mapScreenNavigationTitle = "restaurants_map__navigation_title"
        
        public static let searchRestaurantPickerCityTitle = "search_merchant_spinner_city_gastropay_sdk"
        public static let searchRestaurantPickerRegionTitle = "search_merchant_spinner_region_gastropay_sdk"
        public static let searchRestaurantPickerAreaTitle = "search_merchant_spinner_area_title_gastropay_sdk"
        
        public static let searchBarPlaceholderText = "search_merchant_search_bar_placeholder_gastropay_sdk"

        public struct Detail {
            public static let navigation = "merchant_detail_navigation_button_gastropay_sdk"
            public static let view = "restaurant_detail_search"
            public static let earn = "merchant_detail_earn_gastropay_sdk"
            public static let spend = "merchant_detail_spend_gastropay_sdk"
            public static let yemedenOlmaz = "restaurant_detail_yemeden_olmaz"
            public static let campaign = "restaurant_detail_campaigns"
            public static let gallery = "restaurant_detail_gallery"
            public static let description = "restaurant_detail_description"
            public static let expensivity = "merchant_detail_value_degree_gastropay_sdk"
            public static let address = "restaurant_detail_address"
            public static let viewRestaurants = "restaurant_detail_view_restaurants"
            public static let navigationPopupTitleCancel = "merchant_detail_navigation_cancel_gastropay_sdk"
            public static let navigationPopupTitleAppleMaps = "merchant_detail_navigation_apple_maps_gastropay_sdk"
            public static let navigationPopupTitleGoogleMaps = "merchant_detail_navigation_google_maps_gastropay_sdk"
            public static let navigationPopupTitleYandexMaps = "merchant_detail_navigation_yandex_maps_gastropay_sdk"
        }
    }

    public struct Tutorial {
        public static let titleHome = "showcase_tutorial_home"
        public static let titleRestaurants = "showcase_tutorial_merchant"
        public static let titleCampaigns = "showcase_tutorial_campaign"
        public static let titleWallet = "showcase_tutorial_wallet"
        public static let buttonTitleContinue = "showcase_tutorial_continue"
        public static let buttonTitleClose = "showcase_tutorial_close"
    }

    public struct Campaigns {
        public static let navigationTitle = "campaigns_nav_title"
    }

    public struct CampaignDetail {
        public static let actionButton = "campaign_detail_action_button_text"
        public static let descriptionHeader = "campaigns_detail_description"
    }

    public struct Authentication {
        public struct Login {
            public static let navigationBarTitle = "login_toolbar_title_gastropay_sdk"
            public static let welcomeHeaderText = "login_view_title_gastropay_sdk"
            public static let welcomeHeaderInfoText = "login_view_desc_gastropay_sdk"
            public static let loginButtonText = "login_view_button_gastropay_sdk"
            public static let phonePlaceholder = "login_view_phone_number_hint_gastropay_sdk"
        }

        public struct OneTimePassword {
            public static let navigationTitle = "otp_title"
            public static let welcomeTitle = "otp_label"
            public static let welcomeDescription = "otp_sms_label_gastropay_sdk"
            public static let counterText = "otp_timer_label_gastropay_sdk"
            public static let digitInputLabel = "otp_confirmation_code"
            public static let resendButtonText = "otp_button_resend_gastropay_sdk"
        }

        public struct Register {
            public static let welcomeTitle = "register_welcome_title"
            public static let welcomeTitleDescription = "register_welcome_description"

            public static let contractLabel = "register_contract_label"
            public static let contractLabelBoldPart = "register_contract_bold_part"
            public static let registerInvitationCode = "register_invitation_code"
            
            public static let gdprLabel = "register_gdpr_checkbox"
            public static let gdprLabelBoldPart1 = "register_clarification_toolbar_title"
            public static let gdprLabelBoldPart2 = "register_explicit_consent"
        }
        
        public struct TermsAndAgreements {
            public static let approveButtonText = "button_agree"
            public static let clarificationTitle = "register_clarification_toolbar_title"
            public static let gdprTitle = "register_gdpr_explicit_consent_toolbar_title"
            public static let agreementTitle = "Terms_Agreements"
        }
        
        public struct PinScreen {
            public static let validatePinNavigationTitle = "payment__validate_pin_title"
            public static let createPinNavigationTitle = "payment__create_pin_title"
            public static let updatePinNavigationTitle = "payment__update_pin_title"
        }
    }

    public struct Wallet {
        public static let navigationTitle = "wallet__navigation_title"
        public static let latestTransactionsLabel = "wallet__last_transactions_label"
        public static let spendableYeTLAmount = "wallet__point_spend_amount_label"
        public static let spendableBalanceDetail = "wallet__point_button_detail"
        public static let addedCards = "wallet__defined_credit_card_label"
        public static let addCardButtonTitle = "wallet__add_card_button"
        public static let defaultCardLabel = "wallet__default_card_label"
        public static let cardMenuSetDefault = "wallet__dialog_use_default_card_label"
        public static let cardMenuDeleteCard = "wallet__dialog_remove_card_label"
        public static let cardMenuCancel = "wallet__card_menu__cancel"
        public static let noCardTitle = "wallet__no_credit_card_title"
        public static let noCardDescription = "wallet__no_credit_card_description"
        public static let noCardButtonTitle = "wallet__no_credit_card_button_label"

        public static let detailHeaderText = "wallet_my_saved_points_gastropay_sdk"
        public static let depositText = "wallet_earn_gastropay_sdk"
        public static let withdrawText = "wallet_spend_gastropay_sdk"
        public static let cancelText = "wallet_cancel_gastropay_sdk"
        public static let transactionTitle = "wallet_last_transactions_gastropay_sdk"

        public struct TransactionTypeLabel {
            public static let spending = "wallet_spend_gastropay_sdk"
            public static let cancel = "wallet_cancel_gastropay_sdk"
            public static let deposit = "wallet_earn_gastropay_sdk"
        }

        public struct TransactionDetail {
            public static let navigationTitle = "transaction_detail_navigation_title_gastropay_sdk"
            public static let merchantLabel = "transaction_detail_merchant_label_gastropay_sdk"
            public static let amountLabel = "transaction_detail_amount_label_gastropay_sdk"
            public static let transactionTypeLabel = "transaction_detail_transaction_type_label_gastropay_sdk"
            public static let dateLabel = "transaction_detail_date_label_gastropay_sdk"
            public static let billLabel = "transaction_detail_bill_label_gastropay_sdk"
            public static let invoiceSent = "wallet__transaction_invoice_sent"

            public struct TypeLabel {
                public static let normal = "wallet__transaction_detail_normal"
                public static let cashback = "wallet__transaction_detail_cash_back"
                public static let creditCard = "wallet__transaction_detail_credit_card"
                public static let serviceCost = "wallet__transaction_detail_service_cost"
            }
        }

        public struct AddCard {
            public static let navigationTitle = "add_credit_card__navigation_title"
            public static let cardPlaceholder = "add_credit_card__card_holder_name"
            public static let cardNumber = "add_credit_card__card_number"
            public static let cardExpDate = "add_credit_card__card_expire_date"
            public static let cardCvv = "add_credit_card__card_cvv"
            public static let cardNickname = "add_credit_card__card_alias"
            public static let buttonTitle = "add_credit_card__button_add_card"
        }
    }

    public struct YeTL {
        public static let monthlyEarnedYeTL = "yetl_detail_monthly_earn_yetl"
        public static let totalEarnedYeTL = "yetl_detail_total_earned_yetl"
        public static let monthlyEarnedYeTLTitle = "yetl_detail_monthly_earn_yetl_title"
        public static let earnMore = "yetl_detail_earn_more"
    }

    public struct Network {
        public static let errorTitle = "network__error_title"
    }

    public struct Popups {
        static let registerAddCardTitle = "register_popup_add_card_title"
        static let registerAddCardBody = "register_popup_add_card_body"
        static let cameraPermissionBody = "qr_scan_popup_camera_permission_body_gastropay_sdk"
        static let cameraPermissionButton = "qr_scan_popup_camera_permission_action_button_gastropay_sdk"
        static let locationPermissionBody = "popup_location_permission_body"
        static let locationPermissionButton = "popup_location_permission_action_button"
        static let addCardErrorTitle = "add_card_popup_error_title"
        static let addCardErrorBody = "add_card_popup_error_body"
        static let addCardErrorButton = "add_card_popup_error_action_button"
        static let addCardSuccessBody = "add_card_popup_success_body"
        static let addCardSuccessButton = "add_card_popup_success_action_button"
        static let walletYetlRequiredTitle = "wallet___popup_info_dialog_title"
        static let walletYetlRequiredBody = "wallet___popup_info_dialog_description"
        static let walletYetlRequiredButton = "wallet___popup_info_dialog_button_understand"
        static let puanEarnedBody = "wallet___earn_money_popup_description"
        static let puanEarnedButtonText = "common_done"
    }

    public struct Home {
        public static let navigationTitle = "home_navigation_title"
        public static let registerCellText = "home_header_title"
        public static let headerLoginText = "home_header_login_button"
        public static let tabBarRestaurantsTitle = "bottom_bar_merchants_gastropay_sdk"
        public static let tabBarWalletTitle = "bottom_bar_wallet_gastropay_sdk"
        public static let tabBarPayTitle = "bottom_bar_pay_gastropay_sdk"
    }

    public struct Payment {
        public static let qrNavigationTitle = "qr_scan_qrcode_gastropay_sdk"
        public static let infoNavigationTitle = "payment_confirmation_navigation_title_gastropay_sdk"
        public static let payWithCodeBtn = "qr_pay_with_code_btn"
        public static let payWithCodePopupTitle = "pay_with_code_popup_title"
        public static let payWithCodePopupButtton = "pay_with_code_popup_button"

        public struct InfoScreen {
            public static let amountToPay = "payment_confirmation_amount_payable_title_gastropay_sdk"
            public static let spendableAmountLabel = "payment_confirmation_spendable_amount_label_gastropay_sdk"
            public static let spendingAmountLabel = "payment_confirmation_spended_amount_label_gastropay_sdk"
            public static let spendableButtonText = "payment_confirmation_spendable_amount_button_text_gastropay_sdk"
            public static let spendableButtonActiveText = "payment_confirmation_spendable_amount_button_cancel_text_gastropay_sdk"
            public static let selectCard = "payment_confirmation_select_bank_card_label_gastropay_sdk"
            public static let selectedCard = "payment_confirmation_selected_bank_card_text_gastropay_sdk"

            public static let orderAmount = "payment_confirmation_order_gastropay_sdk"
            public static let spendingAmount = "payment_confirmation_spending_amount_gastropay_sdk"
            public static let totalAmount = "payment_confirmation_total_amount_gastropay_sdk"

            public static let payButtonText = "payment_confirmation_button_pay_gastropay_sdk"
        }

        public struct SuccessScreen {
            public static let successLabel = "payment_success_payment_success_label_gastropay_sdk"
            public static let onlinePaymentInfoLabel = "payment_success__online_information_note"
            public static let experienceLabel = "payment_success_contact_us_header_gastropay_sdk"
            public static let experienceInfoLabel = "payment_success_contact_us_info_gastropay_sdk"
            public static let contactUs = "payment_success_button_contact_us_gastropay_sdk"
            public static let end = "payment_success_done_button_text_gastropay_sdk"
            public static let title = "payment_success_navigation_title_gastropay_sdk"
        }
    }

    public struct Settings {
        public static let notificationChannelSms = "settings_notification_channel_1_gastropay_sdk"
        public static let notificationChannelEmail = "settings_notification_channel_2_gastropay_sdk"
        public static let notificationChannelPush = "settings_notification_channel_3_gastropay_sdk"
        public static let contactUsCall = "contact_us_call_gastropay_sdk"
        public static let contactUsWrite = "contact_us_write_gastropay_sdk"
        public static let navigationTitle = "settings_navigation_title_gastropay_sdk"
        public static let contactUs = "settings_contact_us_gastropay_sdk"
        public static let contactUsTitle = "contact_us_title_gastropay_sdk"
        public static let faq = "settings_faq_gastropay_sdk"
        public static let termsOfUse = "settings_terms_of_use_gastropay_sdk"
        public static let notificationPreferences = "settings_contact_permissions_gastropay_sdk"
        public static let contactUsMailSubject = "contact_us_mail_subject_gastropay_sdk"
    }
    
    public struct Invite {
        public static let topInfoNoCampaign = "profile_invite_friends_description"
        public static let linkCopied = "invite_link_copied"
        public static let shareMessage = "profile_invite_friends_share_message"
        public static let davetiyeKodu = "invite_friends_invitation_code"
    }

    public struct LocationPermissionWarning {
        public static let title = "merchants_warning_location_permission_title_gastropay_sdk"
        public static let description = "merchants_warning_location_permission_description_gastropay_sdk"
    }

    public struct Units {
        public static let merchantsCloseTitle = "home_title_featured"
        public static let merchantListsTitle = "home_title_lists"
        public static let creditCardCampaignsTitle = "home_title_credit_card_campaigns"
        public static let merchantListsCountLabel = "showcase_place"
        public static let campaignsHeaderPlaceholderTitle = "campaigns_header__placeholder_title"
        public static let merchantDistanceLabelKM = "merchants_merchant_distance_label_km_gastropay_sdk"
        public static let merchantDistanceLabelMT = "merchants_merchant_distance_label_mt_gastropay_sdk"
    }

    public struct TimeAgo {
        public static let days = "time_ago_days"
        public static let day = "time_ago_day"
        public static let hours = "time_ago_hours"
        public static let hour = "time_ago_hour"
        public static let minutes = "time_ago_minutes"
        public static let minute = "time_ago_minute"
        public static let seconds = "time_ago_seconds"
        public static let second = "time_ago_second"
        public static let missed = "time_ago_missed"
    }
    
    public struct General {
        public static let cancel = "general__cancel"
        public static let keyboardDoneButton = "common_done_gastropay_sdk"
    }
    
    public struct Profile {
        public static let navigationTitle = "profile_navigation_title"
        public static let contactUs = "profile_contact_us"
        public static let contactUsPageTitle = "Bize Ulaşın"
        public static let howToUse = "profile_how_to_use"
        public static let faq = "profile_faq"
        public static let personalInfo = "profile_personal_info"
        public static let settings = "profile_settings"
        public static let logOut = "profile_log_out"
        public static let termsOfUse = "settings_terms_of_use"
        public static let pinCode = "settings_pin_code"
        public static let notificationPreferences = "settings_contact_permissions_gastropay_sdk"
        public static let notificationPreferencesTitle = "settings_notification_toolbar_title_gastropay_sdk"
        public static let notificationChannelSms = "settings_notification_channel_1_gastropay_sdk"
        public static let notificationChannelEmail = "settings_notification_channel_2_gastropay_sdk"
        public static let notificationChannelPush = "settings_notification_channel_3_gastropay_sdk"
        public static let goToSettings = "settings_notification_go_to_settings"
        public static let askNotificationPermission = "settings_notification_ask_permission"
        public static let contactUsLive = "contact_us_live"
        public static let contactUsCall = "contact_us_call"
        public static let contactUsWrite = "contact_us_write"
        public static let contactUsMailSubject = "contact_us_mail_subject"
        public static let whatsappNotInstalled = "whatsapp_not_installed"
        public static let userInfoGSMMessage = "user_info_gsm_message"
        public static let inviteFriend = "profile_invite_friends"

        public static let personalInfoChangeSuccess = "personal_info__changed_successfully"
        public static let invoiceAddress = "settings_invoice_address"
        
        public struct UpdateInvoice {
            public static let updateInvoiceAddress = "update_invoice_address"
            public static let updateInvoiceCompanyAddress = "update_invoice_company_address"
            public static let updateInvoiceCompanyName = "update_invoice_company_name"
            public static let updateInvoiceDistrict = "update_invoice_district"
            public static let updateInvoiceNavigationTitle = "update_invoice_navigation_title"
            public static let updateInvoiceProvince = "update_invoice_province"
            public static let updateInvoiceTaxNumber = "update_invoice_tax_number"
            public static let updateInvoiceTaxOffice = "update_invoice_tax_office"
            public static let updateInvoiceTckn = "update_invoice_tckn"
            public static let updateInvoiceTypeCompany = "update_invoice_type_company"
            public static let updateInvoiceTypePersonal = "update_invoice_type_personal"
            public static let updateInvoiceButtonText = "button_update"
        }
    }
}
