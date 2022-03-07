//
//  TermsAndAggreementsVC.swift
//  Authentication
//
//  Created by  on 2.03.2020.
//

import UIKit

import WebKit
import Then
import YPNavigationBarTransition

public protocol TermsAndAgreementsProtocol: AnyObject {
    func isuserApprovedConditions(isApproved: Bool)
}

public enum PreviousScreen{
    
    case registerNewUser
    case userAgreements
    
}

public class TermsAndAgreementsVC: MIViewController, NavigationBarConfigureStyle {
    public var viewModel: TermsAndAgreementsVM!
    private let previousScreen: PreviousScreen!
    public var contractLink: String
    private var approveButtonHeight = 50
    public weak var delegate: TermsAndAgreementsProtocol?

    let wkWebView = WKWebView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let navigationTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var approveButtonBottomConstraint: NSLayoutConstraint!
    let approveButton = UIButton().then { (button) in
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .showShadowImage
    }

    public func yp_navigationBarTintColor() -> UIColor! {
        return .black
    }

    public init(contractLink: String, vm: TermsAndAgreementsVM, previousScreen: PreviousScreen) {
        self.contractLink = contractLink
        self.viewModel = vm
        self.previousScreen = previousScreen
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTapApproved() {
        self.delegate?.isuserApprovedConditions(isApproved: true)
        self.navigationController?.popViewController(animated: true)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.titleView = navigationTitleLabel

        view.addSubview(wkWebView)
        

        guard let url = URL(string: contractLink) else {
            return
        }

        wkWebView.load(URLRequest(url: url))
        wkWebView.bindFrameToSuperviewBounds(lefMargin: 16, rightMargin: 16, topMargin: 16, bottomMargin: 16+CGFloat(approveButtonHeight)+5)
        self.navigationTitleLabel.text = viewModel.title

        if !viewModel.isApproveButtonHidden {
            approveButton.setTitle(viewModel.approveButtonText, for: .normal)
            approveButton.backgroundColor = viewModel.registerButtonActiveBackgroundColor
            approveButton.setTitleColor(viewModel.registerButtonActiveTextColor, for: .normal)
            approveButton.setTitleColor(viewModel.registerButtonDisabledTextColor, for: .disabled)
            
            view.addSubview(approveButton)
            approveButton.addTarget(self, action: #selector(onTapApproved), for: .touchUpInside)
            if #available(iOS 11.0, *) {
                approveButtonBottomConstraint = approveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
                NSLayoutConstraint.activate([
                    approveButtonBottomConstraint,
                    approveButton.heightAnchor.constraint(equalToConstant: CGFloat(approveButtonHeight)),
                    approveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    approveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
                ])
            } else {
                approveButtonBottomConstraint = approveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
                NSLayoutConstraint.activate([
                    approveButtonBottomConstraint,
                    approveButton.heightAnchor.constraint(equalToConstant: CGFloat(approveButtonHeight)),
                    approveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    approveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
                ])
            }
            
            if self.previousScreen == .userAgreements{
                approveButtonHeight = 0
                approveButton.isHidden = true
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        approveButton.layer.cornerRadius = approveButton.frame.size.height / 2
    }
    
    
    
    
    
    

}
