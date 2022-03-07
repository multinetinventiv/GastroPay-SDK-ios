//
//  TransactionsVC.swift
//  Wallet
//
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then
import YPNavigationBarTransition

public final class TransactionsVC: MIViewController {
    var viewModel: TransactionsVM!

    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = TransactionsVM(onSetLoadingIndicator: { [weak self] show in
            guard let self = self else { return }
            self.setLoadingState(show: show)
        },onTappedClose: {
            Gastropay.dismissViewController(viewController: self)
        }, onTappedSettings: {
            let profileVC = SettingsVC()
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.setupView(vc: self)
        self.viewModel.onSelectTransaction = didSelectTransaction
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
        Service.getTabbarController()?.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.navigationController?.isNavigationBarHidden = true
        Service.getTabbarController()?.navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        //Service.getTabbarController()?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchTransactions()
    }
    
    func didSelectTransaction(transaction: WalletTransaction) {
        navigationController?.pushViewController(TransactionDetailVC(transaction), animated: true)
    }
}

extension TransactionsVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .hidden
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .white
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return .black
    }
}
