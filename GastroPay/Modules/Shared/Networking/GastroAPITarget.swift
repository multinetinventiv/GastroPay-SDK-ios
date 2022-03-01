***REMOVED***
***REMOVED***  GastroAPITarget.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by  on 4.12.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***



enum GastroTarget {
    case GetSettings
    case Login(phoneNumber: String, deviceId: String)
    case Register(name: String, surname: String, gsmNumber: String, email: String, deviceId: String, notificationConsent: Bool, termsAndConditionsAgreed: Bool, invitationCode: Int? = nil, gdprAgreed: Bool)
    case LoginWithoutOtp(phoneNumber: String, deviceId: String)
    case ConfirmOTP(verificationCode: String, smsCode: String)
    case ConfirmAuthOTP(verificationCode: String, smsCode: String)
    case Wallet
    case getCreditCards
    case RefreshToken
    case setCreditCardDefaultState(cardId: Int, defaultState: Bool)
    case deleteCreditCard(cardId: Int)
    case getTransactions(walletUUID: String, endTimestamp: Int)
    case SendInvoice(transactionId: Int)
    case GetUser
    case GetCampaigns(walletUUID: String? = nil, merchantUUID: String? = nil, campaignType: Int? = nil)
    case GetContractLink
    case AddCreditCard(cardHolderName: String, cardNumber: String, cardExpMonth: String, cardExpYear: String, cardCvv: String, cardAlias: String)
    case PaymentInformation(qrCode: String? = nil, isBonusUsed: Bool = false, tokenType: PaymentTokenType)
    case ConfirmPayment(token: String, cardId: Int, useCashback: Bool, pinCode: String?)
    case ConfirmAndComplete(sign: String, token: String, cardId: Int, pinCode: String?, terminalUid: String, tokenType: PaymentTokenType, useCashback: Bool, requestId: String)
    case GetCampaignRewardPercentage(walletUUID: String, merchantUId: String, binNumber: String, redirectionType: CampaignType)
    case getMerchantLists
    case GetShowcaseMerchants(latitude: Double, longitude: Double)
    case getSearchCriterias(cityId: Int? = nil)
    case GetTransactionSummary
    case GetMerchants(latitude: Double, longitude: Double, isBonusPoint: Bool?, tags: [String]?, merchantName_contains: String?)
    case GetMerchantsInfo(latitude: Double, longitude: Double, isBonusPoint: Bool?, tags: [String]?, cityId: Int?, merchantName_contains: String?, paginationNumber: Int? = nil)
    case UpdatePin(pinCode: String)
    case LogOut
    case UpdateProfile(name: String, surname: String, gsmNumber: String, email: String)
    case GetMerchantDetail(merchantUUID: String)
    case UpdateProfilePhoto(imageData: String)
    case GetNotificationPreferences
    case UpdateNotificationPreference(notificationGroupId: Int, channel: Int, accepted: Bool)
    case SaveMobileDeviceInfo(userId: Int? = nil, deviceUUID: String, AppVersion: String, DeviceToken: String, DeviceName: String, DeviceModel: String, OsVersion: String)
    case GetAllMerchants(hashValue: String?)
    case GetCities
}

extension GastroTarget: GazelRestAPITarget {
    var isMock: Bool { return false }

    var delayTime: TimeInterval { return TimeInterval.random(in: 1..<2) }

    var baseURL: URL {
        return URL(string: ServiceUrl.getBaseURL()) ?? URL(string: "")!
    }

    var path: String {
        switch self {
        case .GetSettings:
            return "gastropay/v1/auth/settings"
        case .Login:
            return "gastropay/v1/auth/login"
        case .LoginWithoutOtp:
            return "gastropay/v1/auth/login_without_otp"
        case .getSearchCriterias:
            return "gastropay/v1/merchant/search_criteria_tag_groups"
        case .Register:
            return "gastropay/v1/auth/register"
        case .ConfirmOTP:
            return "gastropay/v1/auth/otp_validation"
        case .ConfirmAuthOTP:
            return "gastropay/v1/auth/otp_confirm"
        case .Wallet:
            return "gastropay/v1/wallet/wallets"
        case .getCreditCards:
            return "gastropay/v1/wallet/cards"
        case .setCreditCardDefaultState(let cardId, _):
            return "gastropay/v1/wallet/update_is_default/\(cardId)"
        case .deleteCreditCard(let cardId):
            return "gastropay/v1/wallet/delete_credit_card/\(cardId)"
        case .getTransactions(let walletUUID, let endTimestamp):
            return "gastropay/v1/wallet/transactions/\(walletUUID)/\(endTimestamp)"
        case .RefreshToken:
            return "gastropay/v1/auth/refresh_token"
        case .SendInvoice:
            return "gastropay/v1/notify/invoice_send"
        case .GetUser:
            return "gastropay/v1/auth/profile"
        case .GetCampaigns:
            return "gastropay/v1/loyalty/campaigns"
        case .GetContractLink:
            return "gastropay/v1/auth/term_and_condition/1"
        case .AddCreditCard:
            return "gastropay/v1/wallet/credit_cards"
        case .PaymentInformation:
            return "gastropay/v1/pos/provision_information"
        case .ConfirmPayment:
            return "gastropay/v1/pos/confirm_provision"
        case .ConfirmAndComplete:
            return "gastropay/v1/pos/confirm/complete"
        case .GetCampaignRewardPercentage:
            return "gastropay/v1/loyalty/campaign_reward_percentage"
        case .getMerchantLists:
            return "gastropay/v1/merchant/showcase_list"
        case .GetShowcaseMerchants:
            return "gastropay/v1/merchant/showcase_merchants"
        case .GetTransactionSummary:
            return "gastropay/v1/wallet/transaction_summary"
        case .GetMerchants:
            return "gastropay/v1/merchant/merchants"
        case .GetMerchantsInfo:
            return "gastropay/v1/merchant/merchants_info"
        case .UpdatePin:
            return "gastropay/v1/auth/update_pin"
        case .LogOut:
            return "gastropay/v1/auth/logout"
        case .UpdateProfile:
            return "gastropay/v1/auth/update_profile"
        case .GetMerchantDetail:
            return "gastropay/v1/merchant/merchant_detail"
        case .UpdateProfilePhoto:
            return "gastropay/v1/profile/profile_photos"
        case .GetNotificationPreferences:
            return "gastropay/v1/auth/notification_preferences"
        case .UpdateNotificationPreference(let groupId, _, _):
            return "gastropay/v1/auth/update_notification_preferences/\(groupId)"
        case .SaveMobileDeviceInfo:
            return "gastropay/v1/auth/save_mobile_device_info"
        case .GetAllMerchants:
            return "gastropay/v1/merchant/all"
        case .GetCities:
            return "gastropay/v1/merchant/cities"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .PaymentInformation(let qrCode, let isBonusUsed, let paymentTokenType):
            var parameter:[String:Any] = ["isBonusUsed": isBonusUsed]
            
            if let qr = qrCode{
                parameter["token"] = qr
            }
            
            parameter["tokenType"] = paymentTokenType.rawValue
            
            return parameter
            
        case .Login(let phoneNumber, let deviceId):
            return [
                "gsmNumber": phoneNumber,
                "mobileDeviceToken": deviceId
            ]
        case .Register(let name, let surname, let gsm, let email, let deviceId, let notificationConsent, let termsAndConditionsAgreed, let invitationCode, let gdprAgreed):
            
            if let invCode = invitationCode{
                return [
                    "name": name,
                    "surname": surname,
                    "gsmNumber": gsm,
                    "email": email,
                    "mobileDeviceToken": deviceId,
                    "isUserAgreementAccepted": termsAndConditionsAgreed,
                    "IsNotificationAccepted": notificationConsent,
                    "referrerProfileCode" : invCode,
                    "isGdprAccepted" : gdprAgreed
                ]
            }
            else{
                return [
                    "name": name,
                    "surname": surname,
                    "gsmNumber": gsm,
                    "email": email,
                    "mobileDeviceToken": deviceId,
                    "isUserAgreementAccepted": termsAndConditionsAgreed,
                    "IsNotificationAccepted": notificationConsent,
                    "isGdprAccepted" : gdprAgreed
                ]
            }
        
        case .ConfirmOTP(let verificationCode, let smsCode):
            return ["verificationCode": verificationCode, "smsCode": smsCode]
        case .ConfirmAuthOTP(let verificationCode, let smsCode):
            return ["verificationCode": verificationCode, "smsCode": smsCode]
        case .setCreditCardDefaultState(_, let defaultState):
            return ["isDefault": defaultState]
        case .RefreshToken:
            return ["refreshToken": Service.getAuthenticationManager()?.getToken(for: .RefreshToken) ?? ""]
        case .SendInvoice(let transactionId):
            return ["walletTransactionId": String(transactionId)]
        case .GetCampaigns(let walletUUID, let merchantUUID, let campaignType):
            var params: [String: Any] = [:]
            if let walletUUID = walletUUID { params.updateValue(walletUUID, forKey: "clientRefNo") }
            if let merchantUUID = merchantUUID { params.updateValue(merchantUUID, forKey: "merchantId") }
            if let campaignType = campaignType { params.updateValue(campaignType, forKey: "redirectionType") }
            return params
        case .AddCreditCard(let cardHolderName, let cardNumber, let cardExpMonth, let cardExpYear, let cardCvv, let cardAlias):
            return [
                "cardHolderName": cardHolderName,
                "creditCardNumber": cardNumber,
                "expireMonth": cardExpMonth,
                "expireYear": cardExpYear,
                "cardCvv": cardCvv,
                "alias": cardAlias
            ]
        case .ConfirmPayment(let token, let cardId, let useCashback, let pinCode):
            var params: [String: Any] = ["token": token, "cardId": cardId, "useCashback": useCashback]
            if let pinCode = pinCode { params["pinCode"] = pinCode }
            return params
            
        case .ConfirmAndComplete(let sign, let token, let cardId, let pinCode, let terminalUid, let tokenType, let useCashback, let requestId):
            
            var params: [String: Any] = ["token": token, "cardId": cardId, "useCashback": useCashback, "sign": sign, "terminalUid": terminalUid, "tokenType": tokenType.rawValue, "requestId": requestId]
            if let pinCode = pinCode { params["pinCode"] = pinCode }
            return params
            
        case .GetCampaignRewardPercentage(let walletUUID, let merchantUId, let binNumber, let redirectionType):
            return [
                "accountReferenceNumber": walletUUID,
                "merchantReferenceNumber": merchantUId,
                "binNumber": binNumber,
                "redirectionType": redirectionType.rawValue
            ]
        case .GetShowcaseMerchants(let latitude, let longitude):
            return [
                "latitude": String(latitude),
                "longitude": String(longitude)
            ]
        case .GetMerchants(let latitude, let longitude, let isBonusPoint, let tags, let merchantName_contains):
            var params: [String: Any] = ["latitude": latitude, "longitude": longitude]
            if let isBonusPoint = isBonusPoint { params.updateValue(isBonusPoint, forKey: "isBonusPoint") }
            if let tags = tags { params.updateValue(tags.joined(separator: ","), forKey: "tags") }
            if let merchantName_contains = merchantName_contains { params.updateValue(merchantName_contains, forKey: "merchantName") }
            
            return params
            
        case .GetMerchantsInfo(let latitude, let longitude, let isBonusPoint, let tags, let cityId, let merchantName_contains, let pagination):
            var params: [String: Any] = ["latitude": latitude, "longitude": longitude]
            if let isBonusPoint = isBonusPoint { params.updateValue(isBonusPoint, forKey: "isBonusPoint") }
            if let tags = tags { params.updateValue(tags.joined(separator: ","), forKey: "tags") }
            if let merchantName_contains = merchantName_contains { params.updateValue(merchantName_contains, forKey: "merchantName") }
            if let pagination = pagination { params.updateValue(pagination, forKey: "currentPage") }
            
            if let cityId = cityId { params["cityId"] = "\(cityId)" }
            return params
            
        case .UpdatePin(let pinCode):
            return [
                "pinCode": pinCode
            ]
        case .UpdateProfile(let name, let surname, let gsmNumber, let email):
            return [
                "name": name,
                "surname": surname,
                "gsmNumber": gsmNumber,
                "email": email
            ]
        case .GetMerchantDetail(let merchantUUID):
            return [
                "merchantUid": merchantUUID
            ]
        case .UpdateProfilePhoto(let imageData):
            return [
                "imageData": imageData
            ]
        case .UpdateNotificationPreference(_, let channel, let accepted):
            return [
                "channel": channel,
                "newState": accepted ? 1 : 0
            ]
        case .SaveMobileDeviceInfo(let userId, let deviceUUID, let AppVersion, let DeviceToken, let DeviceName, let DeviceModel, let OsVersion):
            var parameters: [String: Any] = [
                "DeviceUuid": deviceUUID,
                "ApplicationName": "GastroPay",
                "AppVersion": AppVersion,
                "DeviceToken": DeviceToken,
                "DeviceName": DeviceName,
                "DeviceModel": DeviceModel,
                "Os": "iOS",
                "OsVersion": OsVersion
            ]

            if let userId = userId {
                parameters.updateValue(userId, forKey: "UserId")
            }
            return parameters
            
        case .GetAllMerchants(let hashValue):
            
            var parameters: [String: Any] = [:]
            
            if let hash = hashValue { parameters["hash"] = hash }
            
            return parameters
            
        case .getSearchCriterias(let cityId):
            if let cityId = cityId {
                return [
                    "cityId": cityId,
                    "newFiltering": true
                ]
            }
            
            return [:]
            
        default:
            return [:]
        }
    }

    var parameterEncoding: NetworkParameterEncoding {
        switch self {
        case .Login, .Register, .ConfirmOTP, .setCreditCardDefaultState, .RefreshToken, .SendInvoice, .PaymentInformation,
             .ConfirmPayment, .ConfirmAndComplete, .GetCampaignRewardPercentage, .UpdatePin, .UpdateProfile, .UpdateProfilePhoto,
             .ConfirmAuthOTP, .UpdateNotificationPreference, .SaveMobileDeviceInfo:
            return NetworkJSONEncoding()
        default:
            return NetworkURLEncoding(destination: .methodDependent, arrayEncoding: .brackets, boolEncoding: .literal)
        }
    }

    var method: NetworkAPIMethod {
        switch self {
        case .Login, .Register, .ConfirmOTP, .RefreshToken, .AddCreditCard, .SendInvoice,
             .PaymentInformation, .ConfirmPayment, .ConfirmAndComplete, .GetCampaignRewardPercentage, .LogOut,
             .UpdateProfilePhoto, .ConfirmAuthOTP, .GetNotificationPreferences, .LoginWithoutOtp, .SaveMobileDeviceInfo:
            return .post
        case .setCreditCardDefaultState, .UpdatePin, .UpdateProfile, .UpdateNotificationPreference:
            return .put
        case .deleteCreditCard:
            return .delete
        default:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var sampleResponseHTTPStatusCode: Int {
        return 200
    }

    var sampleResponseHeaders: [String: String] {
        return [:]
    }

    var task: NetworkAPITask {
        if parameters.count > 0 {
            return .requestParameters(parameters: parameters, encoding: self.parameterEncoding)
        } else {
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .GetAllMerchants:
            return [:]
        default:
            return ["Accept-Encoding": "identity"]
        }
    }
 
    var shouldAuthenticate: Bool {
        return true
    }

    var resultCodeHeaderKey: String {
        return "X-Result-Code"
    }

    var resultMessageHeaderKey: String {
        return "X-Result-Message"
    }

    var accessTokenExpiredResultCode: Int {
        return 40101
    }

    var refreshTokenExpiredResultCode: Int {
        return 40102
    }

    static var refreshTokenEndpoint: NetworkAPITarget {
        return GastroTarget.RefreshToken
    }

    var validationType: NetworkResponseValidationType {
        return .successCodes
    }
}
