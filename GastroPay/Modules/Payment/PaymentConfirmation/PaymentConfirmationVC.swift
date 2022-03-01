***REMOVED***
***REMOVED***  PaymentConfirmationVC.swift
***REMOVED***  Payment
***REMOVED***
***REMOVED***

import UIKit
import YPNavigationBarTransition

public class PaymentConfirmationVC: MIStackableViewController {
    var viewModel: PaymentConfirmationVM!
    
    var gradientProgress: CGFloat = 0.0
    
    init(paymentInformation: NetworkModels.PaymentInformation, qrCode: String, tokenType: PaymentTokenType, isOnlinePayment: Bool = false, viewModel: PaymentConfirmationVM? = nil) {
        if let viewModel = viewModel {
            self.viewModel = viewModel
        } else {
            self.viewModel = PaymentConfirmationVM(paymentInformation: paymentInformation, qrCode: qrCode, tokenType: tokenType, isOnlinePayment: isOnlinePayment)
        }
        
        super.init(stackViewTopConstraintToSafeArea: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if gradientProgress >= 0.3 {
            return .default
        }
        
        return statusBarUpdater?.preferredStatusBarStyle ?? .lightContent
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarUpdater = Bartinter(.init(initialStatusBarStyle: .lightContent))
        self.stackView.delegate = self
        
        extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            stackView.contentInsetAdjustmentBehavior = .never
        }
        
        navigationItem.titleView = viewModel.navigationTitleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.navigationLeftImage, style: .done, target: self, action: #selector(tappedBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewModel.navigationRightImage, style: .done, target: self, action: #selector(tappedClose))

        viewModel.setupView(vc: self)
        viewModel.fetchCards()
        
        viewModel.onCallPaymentServiceComplete = callPaymentServiceComplete
        viewModel.onSetLoadingState = setLoadingState
    }
    
    @objc func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedClose() {
        dismiss(animated: true)
    }
}

extension PaymentConfirmationVC: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight: CGFloat
        
        if #available(iOS 11.0, *) {
            headerHeight = self.viewModel.merchantInfo.frame.height - self.view.safeAreaInsets.top
        } else {
            headerHeight = self.viewModel.merchantInfo.frame.height
        }
        
        let progress = scrollView.contentOffset.y + scrollView.contentInset.top
        var gradientProgress = max(0.0, min(1.0, progress / headerHeight))
        gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress
        
        if self.gradientProgress != gradientProgress {
            self.gradientProgress = gradientProgress
            yp_refreshNavigationBarStyle()
            statusBarUpdater?.refreshStatusBarStyle()
        }
    }
}

extension PaymentConfirmationVC {
    func callPaymentServiceComplete(_ success: Bool) {
        if success {
            let paymentSuccessVC = PaymentResultVC(merchantName: self.viewModel.paymentInformation.merchantName, paymentAmount: self.viewModel.paymentInformation.totalAmount.displayValue, totalAmount: self.viewModel.paymentInformation.totalAmount.displayValue)
            self.navigationController?.pushViewController(paymentSuccessVC, animated: true)
            MIServiceBus.post(MIEventHelper.PaymentCompleted)
        }
    }
}

extension PaymentConfirmationVC: NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        var configuration: YPNavigationBarConfigurations = .backgroundStyleColor
        
        if gradientProgress == 1 {
            configuration = .backgroundStyleOpaque
        }
        
        self.viewModel.navigationTitleLabel.textColor = UIColor(white: 1.0 - gradientProgress, alpha: 1)
        
        return configuration
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return UIColor(white: 1.0 - gradientProgress, alpha: 1.0)
    }
    
    public func yp_navigationBackgroundColor() -> UIColor! {
        return UIColor(white: 1, alpha: gradientProgress)
    }
}
