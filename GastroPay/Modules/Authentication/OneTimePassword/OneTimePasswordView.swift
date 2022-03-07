//
//  OneTimePasswordView.swift
//  Gastropay
//
//  Created by ilker sevim on 30.07.2021.
//

import UIKit

public class OneTimePasswordView: MIStackableView {
    
    let labelWelcome = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let labelWelcomeInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let labelCountInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let digitInputLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let digitInput = DigitInputView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfDigits = 6
        $0.bottomBorderColor = UIColor(red: 236 / 255, green: 236 / 255, blue: 236 / 255, alpha: 1.0)
        $0.nextDigitBottomBorderColor = UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        $0.textColor = UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        $0.acceptableCharacters = "0123456789"
        $0.keyboardType = .decimalPad
        //digitInput.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 1))
        $0.animationType = .spring
    }
    
    let resendButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = false
    }
    var resendButtonBottomConstraint: NSLayoutConstraint!
    
    public override init() {
        super.init()
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(){
        
        digitInput.heightAnchor.constraint(equalToConstant: 25).isActive = true
        stackView.addRows([labelWelcome, labelWelcomeInfo, labelCountInfo, digitInputLabel, digitInput])
        stackView.setInset(forRow: labelWelcome, inset: UIEdgeInsets(top: 24, left: 16, bottom: 8, right: 16))
        stackView.setInset(forRow: labelWelcomeInfo, inset: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        stackView.setInset(forRow: labelCountInfo, inset: UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16))
        stackView.setInset(forRow: digitInputLabel, inset: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16))
        stackView.setInset(forRow: digitInput, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))

        self.addSubview(resendButton)
        if #available(iOS 11.0, *) {
            resendButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            resendButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            resendButtonBottomConstraint = resendButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            resendButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            resendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            resendButtonBottomConstraint = resendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        }
        resendButtonBottomConstraint.isActive = true
        resendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
