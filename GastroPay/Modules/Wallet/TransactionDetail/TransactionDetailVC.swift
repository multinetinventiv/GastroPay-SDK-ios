***REMOVED***
***REMOVED***  TransactionDetailVC.swift
***REMOVED***  Wallet
***REMOVED***
***REMOVED***  Created by  on 20.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import YPNavigationBarTransition

class TransactionDetailVC: MIViewController {
    var viewModel: TransactionDetailVM!

    init(_ walletTransaction: WalletTransaction, viewModel: TransactionDetailVM? = nil) {
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = TransactionDetailVM(transaction: walletTransaction)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setupView(vc: self)
        viewModel.onSetLoadingState = setLoadingState

        view.backgroundColor = viewModel.backgroundColor
        navigationItem.title = viewModel.navigationTitle
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewModel.transactionDetailView.transactionContainer.layer.applySketchShadow(color: UIColor.lightGray.withAlphaComponent(0.5))
        viewModel.transactionDetailView.billContainer.layer.applySketchShadow(color: UIColor.lightGray.withAlphaComponent(0.5))
    }
}

extension TransactionDetailVC: NavigationBarConfigureStyle {
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }

    func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }
}
