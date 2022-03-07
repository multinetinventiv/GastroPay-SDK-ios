//
//  GastroAPI.swift
//  Shared
//
//  Created by  on 25.12.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//




public class GastroAPI {
    var networkAdapter: NetworkAdapterNew<GastroTarget>

    public init() {
        self.networkAdapter = NetworkAdapterBuilderNew<GastroTarget> {
            $0.logNetworkRequests = true
            $0.tokenProvider = GastroAPITokenProvider()
            $0.accessTokenExpiredResultCode = 22805
            $0.refreshTokenExpiredResultCode = 22802
            $0.refreshTokenExpiredCallback = { error in
                Service.getAuthenticationManager()?.userLoggedOut()
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }.build()
    }
    
    public func getAllMerchants(hash: String?, completion: @escaping (Result<AllMerchantsResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.GetAllMerchants(hashValue: hash), completion: completion)
    }

    public func getMerchantLists(completion: @escaping (Result<[MerchantList], Error>) -> Void) {
        networkAdapter.fetchNew(.getMerchantLists, completion: completion)
    }

    public func getCampaigns(merchantUUID: String? = nil, campaignType: CampaignType? = nil, completion: @escaping (Result<[Campaign], Error>) -> Void) {
        networkAdapter.fetchNew(.GetCampaigns(walletUUID: Service.getAuthenticationManager()?.user?.walletUId, merchantUUID: merchantUUID, campaignType: campaignType?.rawValue), completion: completion)
    }

    public func login(phoneNumber: String, deviceToken: String, completion: @escaping (Result<AuthBeforeOtpResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.Login(phoneNumber: phoneNumber, deviceId: deviceToken), completion: completion)
    }

    public func register(name: String, surname: String, gsmNumber: String, email: String, deviceId: String, verificationCode: String? = nil, checkedNotificationConsent: Bool, agreedTermsAndConditions: Bool, invitationCode:Int? = nil, agreedGdpr: Bool, completion: @escaping (Result<AuthBeforeOtpResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.Register(name: name, surname: surname, gsmNumber: gsmNumber, email: email, deviceId: deviceId, notificationConsent: checkedNotificationConsent, termsAndConditionsAgreed: agreedTermsAndConditions, invitationCode: invitationCode, gdprAgreed: agreedGdpr), completion: completion)
    }

    public func confirmOTP(verificationCode: String, smsCode: String, completion: @escaping ((Result<EmptyResponse, Error>) -> Void)) {
        networkAdapter.fetchNew(.ConfirmOTP(verificationCode: verificationCode, smsCode: smsCode), completion: completion)
    }

    public func confirmAuthOTP(verificationCode: String, smsCode: String, completion: @escaping ((Result<ConfirmOTPResponse, Error>) -> Void)) {
        networkAdapter.fetchNew(.ConfirmAuthOTP(verificationCode: verificationCode, smsCode: smsCode), completion: completion)
    }

    public func addCreditCard(cardHolderName: String, cardNumber: String, cardExpMonth: String, cardExpYear: String, cardCvv: String, cardAlias: String, completion: @escaping (Result<CreditCard, Error>) -> Void) {
        networkAdapter.fetchNew(.AddCreditCard(cardHolderName: cardHolderName,
                                               cardNumber: cardNumber,
                                               cardExpMonth: cardExpMonth,
                                               cardExpYear: cardExpYear,
                                               cardCvv: cardCvv,
                                               cardAlias: cardAlias), completion: completion)
    }

    public func getCreditCards(completion: @escaping (Result<[CreditCard], Error>) -> Void) {
        networkAdapter.fetchNew(.getCreditCards, completion: completion)
    }

    public func getWallets(completion: @escaping (Result<Wallet, Error>) -> Void) {
        networkAdapter.fetchNew(.Wallet, completion: completion)
    }

    public func getSearchCriterias(cityId: Int? = nil, completion: @escaping (Result<[NetworkModels.SearchCriteria], Error>) -> Void) {
        _ = networkAdapter.fetchNew(.getSearchCriterias(cityId: cityId), completion: completion)
    }

    public func setDefaultStateForCard(id: Int, defaultCardState: Bool, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.setCreditCardDefaultState(cardId: id, defaultState: defaultCardState), completion: completion)
    }

    public func deleteCreditCard(id: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.deleteCreditCard(cardId: id), completion: completion)
    }

    public func getWalletTransactions(walletUUID: String, endTimestamp: Int, completion: @escaping (Result<[WalletTransaction], Error>) -> Void) {
        networkAdapter.fetchNew(.getTransactions(walletUUID: walletUUID, endTimestamp: endTimestamp), completion: completion)
    }

    public func sendInvoice(id invoiceId: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.SendInvoice(transactionId: invoiceId), completion: completion)
    }

    public func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        networkAdapter.fetchNew(.GetUser, completion: completion)
    }

    public func getSettings(completion: @escaping (Result<NetworkModels.Settings, Error>) -> Void) {
        networkAdapter.fetchNew(.GetSettings, completion: completion)
    }

    public func getContractLink(completion: @escaping (Result<NetworkModels.ContractLink, Error>) -> Void) {
        networkAdapter.fetchNew(.GetContractLink, completion: completion)
    }

    public func getPaymentInformation(qrCode: String? = nil ,isBonusUsed: Bool = false, tokenType: PaymentTokenType, completion: @escaping (Result<NetworkModels.PaymentInformation, Error>) -> Void) {
        networkAdapter.fetchNew(.PaymentInformation(qrCode: qrCode, isBonusUsed: isBonusUsed, tokenType: tokenType), completion: completion)
    }

    public func confirmPayment(token: String, cardId: Int, useCashback: Bool, pinCode: String? = nil, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.ConfirmPayment(token: token, cardId: cardId, useCashback: useCashback, pinCode: pinCode), completion: completion)
    }
    
    public func confirmAndComplete(sign: String, token: String, cardId: Int, useCashback: Bool, pinCode: String? = nil, terminalUid: String, tokenType: PaymentTokenType, requestId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.ConfirmAndComplete(sign: sign, token: token, cardId: cardId, pinCode: pinCode, terminalUid: terminalUid, tokenType: tokenType, useCashback: useCashback, requestId: requestId), completion: completion)
    }

    public func getCampaignRewardPercentage(walletUUID: String, merchantUId: String, binNumber: String, redirectionType: CampaignType, completion: @escaping (Result<NetworkModels.CampaignRewardPercentage, Error>) -> Void) {
        networkAdapter.fetchNew(.GetCampaignRewardPercentage(walletUUID: walletUUID, merchantUId: merchantUId, binNumber: binNumber, redirectionType: redirectionType), completion: completion)
    }

    public func getShowcaseMerchants(latitude: Double, longitude: Double, completion: @escaping (Result<[Merchant], Error>) -> Void) {
        networkAdapter.fetchNew(.GetShowcaseMerchants(latitude: latitude, longitude: longitude), completion: completion)
    }

    public func getWalletTransactionSummary(completion: @escaping (Result<NetworkModels.WalletTransactionSummary, Error>) -> Void) {
        networkAdapter.fetchNew(.GetTransactionSummary, completion: completion)
    }

    public func getMerchants(latitude: Double, longitude: Double, isBonusPoint: Bool? = nil, tags: [String]? = nil, merchantName_contains: String? = nil, completion: @escaping (Result<[Merchant], Error>) -> Void) {
            
        networkAdapter.fetchNew(.GetMerchants(latitude: latitude, longitude: longitude, isBonusPoint: isBonusPoint, tags: tags, merchantName_contains: merchantName_contains), completion: completion)
        
    }
    
    public func getMerchantsInfo(latitude: Double, longitude: Double, isBonusPoint: Bool? = nil, tags: [String]? = nil, cityId: Int? = nil, merchantName_contains: String? = nil, paginationNumber: Int? = nil, completion: @escaping (Result<MerchantResponse, Error>) -> Void) {
        
        networkAdapter.fetchNew(.GetMerchantsInfo(latitude: latitude, longitude: longitude, isBonusPoint: isBonusPoint, tags: tags, cityId: cityId, merchantName_contains: merchantName_contains, paginationNumber: paginationNumber), completion: completion)
    }

    public func updatePin(pinCode: String, completion: @escaping (Result<AuthBeforeOtpResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.UpdatePin(pinCode: pinCode), completion: completion)
    }

    public func logOut(completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.LogOut, completion: completion)
    }

    public func updateProfile(name: String, surname: String, gsmNumber: String, email: String, completion: @escaping (Result<AuthBeforeOtpResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.UpdateProfile(name: name, surname: surname, gsmNumber: gsmNumber, email: email), completion: completion)
    }

    public func getMerchantDetail(merchantUUID: String, completion: @escaping (Result<NetworkModels.MerchantDetailed, Error>) -> Void) {
        networkAdapter.fetchNew(.GetMerchantDetail(merchantUUID: merchantUUID), completion: completion)
    }

    public func updateProfilePhoto(imageData: String, completion: @escaping (Result<NetworkModels.UpdateProfilePhotoResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.UpdateProfilePhoto(imageData: imageData), completion: completion)
    }

    public func getNotificationPreferences(completion: @escaping (Result<[NetworkModels.NotificationPreference], Error>) -> Void) {
        networkAdapter.fetchNew(.GetNotificationPreferences, completion: completion)
    }

    public func updateNotificationPreference(groupId: Int, channel: Int, accepted: Bool, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        networkAdapter.fetchNew(.UpdateNotificationPreference(notificationGroupId: groupId, channel: channel, accepted: accepted), completion: completion)
    }

    public func saveMobileDeviceInfo(userId: Int? = nil, deviceUUID: String, AppVersion: String, DeviceToken: String, DeviceName: String, DeviceModel: String, OsVersion: String, completion: @escaping (Result<NetworkModels.SaveMobileDeviceInfo, Error>) -> Void) {
        networkAdapter.fetchNew(.SaveMobileDeviceInfo(userId: userId, deviceUUID: deviceUUID, AppVersion: AppVersion, DeviceToken: DeviceToken, DeviceName: DeviceName, DeviceModel: DeviceModel, OsVersion: OsVersion), completion: completion)
    }
    
    public func getCities(completion: @escaping (Result<NetworkModels.Cities, Error>) -> Void) {
        networkAdapter.fetchNew(.GetCities, completion: completion)
    }

}
