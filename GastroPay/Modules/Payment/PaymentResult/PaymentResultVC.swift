***REMOVED***
***REMOVED***  PaymentSuccessVC.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***  Created by Hasan Hüseyin Gücüyener on 3.01.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import YPNavigationBarTransition

public class PaymentResultVC: MIViewController {
    let viewModel: PaymentResultVM!
    
    init(merchantName: String, paymentAmount: String, viewModel: PaymentResultVM? = nil, totalAmount: String?) {
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = PaymentResultVM(merchantName: merchantName, paymentAmount: paymentAmount, totalAmount: totalAmount)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarUpdater?.preferredStatusBarStyle ?? .lightContent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarUpdater = Bartinter(.init(initialStatusBarStyle: .lightContent))

        viewModel.setupView(vc: self)
        viewModel.paymentResultView.endButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        viewModel.paymentResultView.contactUsButton.addTarget(self, action: #selector(tappedContactUs), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: ImageHelper.Icons.close, style: .done, target: self, action: #selector(tappedClose))
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.titleView = viewModel.navigationTitleLabel
    }
    
    @objc func tappedClose() {
        self.dismiss(animated: true) {
            Service.getTabbarController()?.selectedIndex = 2
            Gastropay.delegate?.paymentSucceed()
        }
    }
    
    @objc func tappedContactUs() {
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.paymentResultView.contactUsButton.layer.cornerRadius = viewModel.paymentResultView.contactUsButton.frame.height / 2
    }
}

extension PaymentResultVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return .white
    }
}
