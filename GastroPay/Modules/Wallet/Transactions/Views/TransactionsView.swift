***REMOVED***
***REMOVED***  TransactionsView.swift
***REMOVED***  Gastropay
***REMOVED***
***REMOVED***

import UIKit

class TransactionsView: UIView {
    var topBarView: TopBarView = {
        let topBarView = TopBarView()
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        return topBarView
    }()
    
    public var stackView: MIStackView = {
        let stackView = MIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.hidesSeparatorsByDefault = true
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    var onTappedSettings: (() -> ())? {
        didSet {
            topBarView.onTappedSettings = onTappedSettings
        }
    }
    var onTappedClose: (() -> ())? {
        didSet {
            topBarView.onTappedClose = onTappedClose
        }
    }
    
    func setupView() {
        addSubview(topBarView)
        topBarView.heightAnchor.constraint(equalToConstant: 88.0 + UIApplication.shared.statusBarFrame.size.height).isActive = true
        topBarView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topBarView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topBarView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
