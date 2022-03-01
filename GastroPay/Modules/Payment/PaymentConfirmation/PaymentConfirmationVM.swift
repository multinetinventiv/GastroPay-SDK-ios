***REMOVED***
***REMOVED***  PaymentConfirmationVM.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***  Created by Ramazan Oz on 2.09.2021.
***REMOVED***

import Foundation
import UIKit

class PaymentConfirmationVM {
    public var backgroundColor = ColorHelper.PaymentConfirmation.backgroundColor
    public var navigationTitleFont = FontHelper.Navigation.title
    public var navigationTitleTextColor = UIColor.white
    public var navigationLeftImage = ImageHelper.Icons.backArrow
    public var navigationRightImage = ImageHelper.Icons.close
    
    public var payButtonBackgroundColor = ColorHelper.Button.backgroundColor
    public var payButtonTitleFont = FontHelper.semiBoldTextFont(size: 17)
    public var payButtonTitleText = Localization.Payment.InfoScreen.payButtonText.local
    public var payButtonTitleTextColor = ColorHelper.Button.textColor
    
    var paymentInformation: NetworkModels.PaymentInformation
    var qrCode: String
    var tokenType: PaymentTokenType
    var isOnlinePayment: Bool = false
    
    var shouldSpendYeTL: Bool = false
    
    var selectedCard: CreditCard?
    
    var creditCards: [CreditCard]? {
        didSet {
            if let cards = self.creditCards {
                selectCard.initCards(cards: cards)
            }
        }
    }
    
    let navigationTitleLabel = UILabel()
    
    let merchantInfo = MerchantInfoView()
    let expendableBalance = ExpendableBalance()
    let selectCard = PaymentSelectCard()
    
    var paymentSummary: PaymentAmountInfo
    
    let payButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = false
    }
    
    var onSetLoadingState: ((Bool) -> ())? = nil
    var onCallPaymentServiceComplete: ((_ success: Bool) -> ())? = nil
    
    public init(paymentInformation: NetworkModels.PaymentInformation, qrCode: String, tokenType: PaymentTokenType, isOnlinePayment: Bool = false) {
        self.paymentInformation = paymentInformation
        self.qrCode = qrCode
        self.tokenType = tokenType
        self.isOnlinePayment = isOnlinePayment
        self.paymentSummary = PaymentAmountInfo(paymentInformation: paymentInformation)
    }
    
    func setupView(vc: MIStackableViewController) {
        vc.view.backgroundColor = backgroundColor
        navigationTitleLabel.text = paymentInformation.merchantName.count > 0 ? paymentInformation.merchantName : Localization.Payment.SuccessScreen.title
        navigationTitleLabel.font = self.navigationTitleFont
        navigationTitleLabel.textColor = self.navigationTitleTextColor
        
        merchantInfo.labelPrice.text = paymentInformation.totalAmount.displayValue
        
        paymentSummary.translatesAutoresizingMaskIntoConstraints = false
        
        vc.stackView.addRow(merchantInfo)
        vc.stackView.setBackgroundColor(forRow: merchantInfo, color: .white)
        vc.stackView.setInset(forRow: merchantInfo, inset: .zero)
        if(paymentInformation.availableAmount.value > 0) {
            vc.stackView.addRow(expendableBalance)
            expendableBalance.onTapStateButton = yetlStateChange
            vc.stackView.setBackgroundColor(forRow: expendableBalance, color: .white)
            vc.stackView.setInset(forRow: expendableBalance, inset: UIEdgeInsets(top: 32, left: 16, bottom: 48, right: 16))
        }
        vc.stackView.addRow(paymentSummary)
        vc.stackView.setInset(forRow: paymentSummary, inset: .zero)
        vc.stackView.addRow(selectCard)
        vc.stackView.setInset(forRow: selectCard, inset: .zero)
        selectCard.onSelectCard = selectedCard
        initPaymentInformation(from: paymentInformation)
        
        vc.view.addSubview(payButton)
        
        payButton.setTitleColor(payButtonTitleTextColor, for: .normal)
        payButton.backgroundColor = payButtonBackgroundColor
        payButton.titleLabel?.font = payButtonTitleFont
        payButton.setTitle(payButtonTitleText, for: .normal)
        
        if #available(iOS 11.0, *) {
            payButton.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            payButton.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            payButton.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            payButton.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
            payButton.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
            payButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
        }
        payButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        vc.stackView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        payButton.addTarget(self, action: #selector(onTapPay), for: .touchUpInside)
    }
    
    func selectedCard(_ card: CreditCard) {
        paymentSummary.updateWithModel(paymentInformation: paymentInformation, spendYetlState: shouldSpendYeTL, fetchedRewardPercentage: false)
        self.selectedCard = card
    }
    
    @objc func onTapPay() {
        callPaymentService()
    }
    
    func fetchCards() {
        Service.getAPI()?.getCreditCards {[weak self] (result) in
            guard let self = self else { return }
            
            switch(result) {
            case .success(let cards):
                self.creditCards = cards
                for card in cards {
                    if card.isDefault! {
                        self.selectedCard = card
                    }
                }
                self.payButton.isEnabled = true
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
    
    func callPaymentService() {
        self.onSetLoadingState?(true)

        if paymentInformation.callType == .confirmProvision {
            Service.getAPI()?.confirmPayment(token: paymentInformation.token, cardId: selectedCard!.id!, useCashback: self.shouldSpendYeTL) {[weak self] (result) in
                guard let self = self else { return }
                
                defer { self.onSetLoadingState?(false) }
                
                switch result {
                case .success(_):
                    self.onCallPaymentServiceComplete?(true)
                case .failure(let error):
                    Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
                    
                    self.onCallPaymentServiceComplete?(false)
                }
            }
        }
    }
    
    @objc func yetlStateChange(_ spending: Bool) {
        shouldSpendYeTL = spending
        getPaymentInformation()
    }
    
    func getPaymentInformation() {
        onSetLoadingState?(true)
        
        Service.getAPI()?.getPaymentInformation(qrCode: qrCode, isBonusUsed: shouldSpendYeTL, tokenType: self.tokenType) {[weak self] (result) in
            guard let self = self else { return }
            
            defer { self.onSetLoadingState?(false) }
            
            switch result {
            case .success(let paymentInformation):
                self.initPaymentInformation(from: paymentInformation)
            case .failure(let error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }
    
    func initPaymentInformation(from paymentInformation: NetworkModels.PaymentInformation) {
        self.paymentInformation = paymentInformation
        expendableBalance.updateWithModel(paymentInformation: paymentInformation, isSpending: shouldSpendYeTL)
        paymentSummary.updateWithModel(paymentInformation: paymentInformation, spendYetlState: shouldSpendYeTL)
    }
}
