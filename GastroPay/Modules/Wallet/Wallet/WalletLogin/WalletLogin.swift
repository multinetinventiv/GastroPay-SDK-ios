***REMOVED***
***REMOVED***  WalletLogin.swift
***REMOVED***  Wallet
***REMOVED***
***REMOVED***  Created by  on 8.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import YPNavigationBarTransition
import SkeletonView

class WalletLoginVC: MIStackableViewController, NavigationBarConfigureStyle {
    let spendableView = SpendableView()
    let creditCardsView = CreditCardsView()
    let creditCardCampaigns = CreditCardCampaigns()
    let noCardView = NoCardView()

    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .backgroundStyleColor
    }

    func yp_navigationBackgroundColor() -> UIColor! {
        return .white
    }

    func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }

    let navigationTitleView = UILabel().then {
        $0.text = Localization.Wallet.navigationTitle.local
        $0.font = FontHelper.Navigation.title
        $0.textColor = ColorHelper.activeColor
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    let networkDispatchGroup = DispatchGroup()

    var walletModel: Wallet? {
        didSet {
            if let wallet = self.walletModel {
                self.spendableView.setSpendableAmount(amount: wallet.availableBalance)
                self.spendableView.requiredBalance = wallet.minimumRequiredBalance.displayValue
                self.spendableView.blockedBalance = wallet.blockedBalance.displayValue
            }
        }
    }
    var creditCards: [CreditCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        refreshScreen()

        creditCardsView.addCardCallback = tappedAddCard
        creditCardsView.deleteCardCallback = tappedDeleteCard(_:)
        noCardView.addCardButton.addTarget(self, action: #selector(tappedAddCard), for: .touchUpInside)

        creditCardCampaigns.onSelectCampaign = {campaign in
            MIEventHelper.openCampaignDetail(campaign)
        }

        spendableView.onTapDetail = {
***REMOVED***            let yetlDetailVC = PuanDetailVC()
***REMOVED***            yetlDetailVC.hidesBottomBarWhenPushed = true
***REMOVED***            self.navigationController?.pushViewController(yetlDetailVC, animated: true)
        }

        MIServiceBus.onMainThread(self, name: MIEventHelper.PaymentCompleted) {[weak self] (_) in
            Service.setLoadingStateFor(tabName: .wallet, state: true)
            self?.fetchWalletInfo {
                Service.setLoadingStateFor(tabName: .wallet, state: false)
            }
        }

        MIServiceBus.onMainThread(self, name: MIEventHelper.CreditCardsUpdated) {[weak self] (_) in
            Service.setLoadingStateFor(tabName: .wallet, state: true)
            self?.fetchCreditCardCampaigns {
                Service.setLoadingStateFor(tabName: .wallet, state: false)
            }
        }

        MIServiceBus.onMainThread(self, name: MIEventHelper.NewCardAdded) {[weak self] (_) in
            Service.setLoadingStateFor(tabName: .wallet, state: true)
            self?.fetchCards {
                self?.switchViewState()
                Service.setLoadingStateFor(tabName: .wallet, state: false)
            }
        }

        networkDispatchGroup.notify(queue: .main) {[weak self] in
            guard let self = self else { return }
            Service.setLoadingStateFor(tabName: .wallet, state: false)
            self.switchViewState()
        }
    }

    @objc func tappedAddCard() {
        let addCardViewModel = AddCardViewModel()
        addCardViewModel.showSuccessPopup = true
        addCardViewModel.onSuccessBeforePopupPresent = {[weak self] (creditCard) in
            guard let self = self else { return }
            self.creditCards.append(creditCard)
            self.creditCardsView.setCards(cards: self.creditCards)
            self.switchViewState()
            MIServiceBus.post(MIEventHelper.CreditCardsUpdated)
            self.navigationController?.popToViewController(self.parent!, animated: true)
        }
        addCardViewModel.onSuccessPopupAction = {
***REMOVED***            if let waitingDeepLinkModel = Service.getNotificationManager().waitingDeepLinkModel, waitingDeepLinkModel.type == .paymentWithToken
***REMOVED***            {
***REMOVED***                MIServiceBus.post(MIEventHelper.StartPaymentFlow)
***REMOVED***            }
        }
        let addCardVC = AddCardVC(with: addCardViewModel)
        addCardVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        parent?.navigationItem.titleView = self.navigationTitleView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageHelper.Icons.user, style: .plain, target: self, action: #selector(tappedProfile))
        parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: ImageHelper.Icons.search, style: .plain, target: self, action: #selector(tappedSearch))

        setNeedsStatusBarAppearanceUpdate()
    }

    @objc func tappedProfile() {
***REMOVED***        let profileVC = ProfileVC()
***REMOVED***        profileVC.hidesBottomBarWhenPushed = true
***REMOVED***        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc func tappedSearch() {
        let filterRestaurantsNC = UINavigationController(rootViewController: FilterRestaurantsVC())
        filterRestaurantsNC.modalPresentationStyle = .fullScreen
        present(filterRestaurantsNC, animated: true)
    }

    func tappedDeleteCard(_ id: Int) {
        Service.setLoadingStateFor(tabName: .wallet, state: true)
        Service.getAPI()?.deleteCreditCard(id: id) {[weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(_):
                self.creditCards = self.creditCards.filter({ (card) -> Bool in
                    card.id != id
                })
                self.creditCardsView.setCards(cards: self.creditCards)
                self.switchViewState()
                MIServiceBus.post(MIEventHelper.CreditCardsUpdated)
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
    
    func switchViewState() {
        DispatchQueue.main.async {
            if self.creditCards.isEmpty {
                if self.spendableView.superview != nil {
                    self.stackView.removeRow(self.spendableView, animated: true)
                }
                
                if self.creditCardsView.superview != nil {
                    self.stackView.removeRow(self.creditCardsView, animated: true)
                }
                
                if self.creditCardCampaigns.superview != nil {
                    self.stackView.removeRow(self.creditCardCampaigns, animated: true)
                }
                
                if self.noCardView.superview == nil {
                    self.stackView.addRow(self.noCardView, animated: true)
                    self.stackView.setInset(forRow: self.noCardView, inset: .zero)
                }
            } else {
                if self.noCardView.superview != nil {
                    self.stackView.removeRow(self.noCardView)
                }
                
                if self.spendableView.superview == nil {
                    self.stackView.addRow(self.spendableView, animated: true)
                    self.stackView.setInset(forRow: self.spendableView, inset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                }
                
                if self.creditCardsView.superview == nil {
                    self.creditCardsView.setCards(cards: self.creditCards)
                    self.stackView.addRow(self.creditCardsView, animated: false)
                }
                
                if self.creditCardCampaigns.superview == nil, !self.creditCardCampaigns.isCampaignsEmpty() {
                    self.stackView.addRow(self.creditCardCampaigns, animated: true)
                    self.stackView.setInset(forRow: self.creditCardCampaigns, inset: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0))
                }
            }
        }

    
    }

    func refreshScreen() {
        refreshWalletInfo()
        refreshCards()

        networkDispatchGroup.enter()
        fetchCreditCardCampaigns {[weak self] in
            self?.networkDispatchGroup.leave()
        }
    }

    func refreshWalletInfo() {
        Service.setLoadingStateFor(tabName: .wallet, state: true)

        networkDispatchGroup.enter()
        fetchWalletInfo {[weak self] in
            self?.networkDispatchGroup.leave()
        }
    }

    func refreshCards() {
        Service.setLoadingStateFor(tabName: .wallet, state: true)

        networkDispatchGroup.enter()
        fetchCards {[weak self] in
            self?.networkDispatchGroup.leave()
        }
    }
}

extension WalletLoginVC {
    func fetchCards(_ completion: @escaping (() -> Void)) {
        Service.getAPI()?.getCreditCards { [weak self] (result) in
            guard let self = self else { return }

            defer { completion() }

            switch result {
            case let .success(cards):
                self.creditCards = cards
            case let .failure(error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }

    func fetchCreditCardCampaigns(_ completion: @escaping (() -> Void)) {
        Service.getAPI()?.getCampaigns(campaignType: .creditCard) { [weak self] (result) in
            guard let self = self else { return }

            defer { completion() }

            switch result {
            case let .success(campaigns):
                self.creditCardCampaigns.reloadWith(creditCardCampaigns: campaigns)
            case let .failure(error):
                Service.getPopupManager()?.showCardMessage(theme: .error, title: Localization.Network.errorTitle.local, body: error.localizedDescription)
            }
        }
    }

    func fetchWalletInfo(_ completion: @escaping (() -> Void)) {
        Service.getAPI()?.getWallets {[weak self] (result) in
            guard let self = self else { return }

            defer { completion() }

            switch result {
            case .success(let wallet):
                self.walletModel = wallet
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
}
