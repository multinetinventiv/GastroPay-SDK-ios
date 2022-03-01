***REMOVED***
***REMOVED***  LoginView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***  Created by ilker sevim on 30.07.2021.
***REMOVED***

import Foundation

public class LoginView: MIStackableView {
    
    let welcomeHeader = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let welcomeHeaderInfo = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    var phoneInputController: MITextFieldControllerOutlined!
    let phoneInput = MITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.inputType = .phone
        $0.keyboardType = .phonePad
    }
    
    var loginButtonBottomConstraint: NSLayoutConstraint!
    
    let loginButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = false
    }
    
    let navigationTitleLabel = UILabel()
    
    public override init() {
        super.init()
        
        self.backgroundColor = .white
    }
    
    public func setupView(){
        
        stackView.addRow(welcomeHeader)
        stackView.setInset(forRow: welcomeHeader, inset: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
        
        stackView.addRow(welcomeHeaderInfo)
        stackView.setInset(forRow: welcomeHeaderInfo, inset: UIEdgeInsets(top: 16, left: 16, bottom: 30, right: 16))
        
        stackView.addRow(phoneInput)
        
        addSubview(loginButton)
        
        if #available(iOS 11.0, *) {
            loginButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            loginButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            loginButtonBottomConstraint = loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        }
        loginButtonBottomConstraint.isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
