//
//  PaymentResultVM.swift
//  Gastropay
//
//  Created by Ramazan Oz on 9.09.2021.
//

import Foundation

class PaymentResultVM {
    let navigationTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Navigation.title
    }
    let paymentResultView = PaymentResultView()
    let merchantName: String
    let paymentAmount: String
    let totalAmount: String?

    init(merchantName: String, paymentAmount: String, totalAmount: String?) {
        self.merchantName = merchantName
        self.paymentAmount = paymentAmount
        self.totalAmount = totalAmount
    }
    
    func setupView(vc: MIViewController) {
        paymentResultView.setupView()
        vc.view.backgroundColor = .white
        navigationTitleLabel.text = merchantName
        paymentResultView.spentAmountLabel.text = paymentAmount
        paymentResultView.spentAmountLabel.text = totalAmount ?? ""
                
        vc.view.addSubview(paymentResultView)
        paymentResultView.bindFrameToSuperviewBounds()
    }
}
