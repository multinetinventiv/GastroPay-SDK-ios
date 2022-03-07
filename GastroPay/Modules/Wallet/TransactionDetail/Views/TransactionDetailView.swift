//
//  TransactionDetailView.swift
//  Gastropay
//
//  Created by on 17.09.2021.
//

import Foundation
import UIKit

class TransactionDetailView: UIView {
    let transactionContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
    }

    let transactionInfoTableView = ContentSizedTableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TransactionDetailCell.self)
        $0.backgroundColor = .clear
    }

    let billContainer = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
    }

    let billLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let billNumber = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let shareIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = ImageHelper.Icons.share
        $0.isUserInteractionEnabled = true
    }
    
    @objc var onTapShareIcon: (() -> ())? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(transaction: WalletTransaction) {
        addSubview(transactionContainer)
        transactionContainer.addSubview(transactionInfoTableView)
        transactionInfoTableView.alwaysBounceVertical = false
        transactionInfoTableView.isUserInteractionEnabled = false
        transactionInfoTableView.separatorStyle = .none
        transactionInfoTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        if #available(iOS 11.0, *) {
            transactionContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            transactionContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            transactionContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        } else {
            transactionContainer.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            transactionContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            transactionContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        }
        
        NSLayoutConstraint.activate([
            transactionInfoTableView.topAnchor.constraint(equalTo: transactionContainer.topAnchor),
            transactionInfoTableView.leadingAnchor.constraint(equalTo: transactionContainer.leadingAnchor),
            transactionInfoTableView.trailingAnchor.constraint(equalTo: transactionContainer.trailingAnchor),
            transactionInfoTableView.bottomAnchor.constraint(equalTo: transactionContainer.bottomAnchor)
        ])
        
        if transaction.invoiceNumber != nil {
            addSubview(billContainer)
            billContainer.addSubview(billLabel)
            billContainer.addSubview(billNumber)
            billContainer.addSubview(shareIcon)
            
            shareIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedShareIcon)))
            
            if #available(iOS 11.0, *) {
                billContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
                billContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
            } else {
                billContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
                billContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
            }
            
            NSLayoutConstraint.activate([
                billContainer.topAnchor.constraint(equalTo: transactionContainer.bottomAnchor, constant: 16),
                billContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                billLabel.topAnchor.constraint(equalTo: billContainer.topAnchor, constant: 16),
                billLabel.leadingAnchor.constraint(equalTo: transactionContainer.leadingAnchor, constant: 16),
                billLabel.trailingAnchor.constraint(lessThanOrEqualTo: billNumber.leadingAnchor),
                billNumber.topAnchor.constraint(equalTo: billLabel.topAnchor),
                shareIcon.topAnchor.constraint(equalTo: billLabel.topAnchor),
                shareIcon.leadingAnchor.constraint(equalTo: billNumber.trailingAnchor, constant: 8),
                shareIcon.widthAnchor.constraint(equalToConstant: 20),
                shareIcon.heightAnchor.constraint(equalToConstant: 18),
                shareIcon.trailingAnchor.constraint(equalTo: transactionContainer.trailingAnchor, constant: -16),
                billLabel.bottomAnchor.constraint(equalTo: billContainer.bottomAnchor, constant: -16)
            ])
            
        } else {
            if #available(iOS 11.0, *) {
                transactionContainer.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
            } else {
                transactionContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16).isActive = true
            }
        }
    }
    
    @objc func tappedShareIcon() {
        onTapShareIcon?()
    }
}
