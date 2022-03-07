//
//  CampaignsHeaderCollectionAuthenticationCell.swift
//  Units
//
//  Created by  on 4.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

extension String {
    public var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    public var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public func fullrange() -> NSRange {
        return NSMakeRange(0, self.count)
    }
}

class CampaignsHeaderCollectionAuthenticationCell: UICollectionViewCell {
    var onTapRegister: (() -> Void)?
    var onTapLogin: (() -> Void)?
    
    var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorHelper.CampaignsHeader.cardBackgroundRegister
        return view
    }()
    
    var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ÜCRETSİZ ÜYE OL", for: .normal)
        button.backgroundColor = ColorHelper.Button.backgroundColor
        button.setTitleColor(ColorHelper.Button.textColor, for: .normal)
        button.titleLabel?.font = FontHelper.semiBoldTextFont(size: 17)
        return button
    }()
    
    var actionButtonLogin: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.clear, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        initCardView()
        initActionButton()
        initAuthenticationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCardView() {
        contentView.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        self.dropShadow()
    }
    
    func initAuthenticationLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.Home.registerCellText.local
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
        cardView.addSubview(label)
        
        label.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16.0).isActive = true
        label.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16.0).isActive = true
        label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16.0).isActive = true
        label.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.0).isActive = true
        
        let label2 = UILabel()
        let text = Localization.Home.headerLoginText.local
        label2.attributedText = text.htmlToAttributedString
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.numberOfLines = 0
        label2.textColor = .white
        label2.textAlignment = .center
        label2.font = FontHelper.semiBoldTextFont(size: 17)
        cardView.addSubview(label2)
        
        label2.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 197.0 / 343.0 * 1.25).isActive = true
        label2.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        label2.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10.0).isActive = true
        label2.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
    }
    
    func initActionButton() {
        cardView.addSubview(actionButton)
        
        actionButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 197.0 / 343.0).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -50.0).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        actionButton.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.bounds.size.height / 2.0
        actionButton.addTarget(self, action: #selector(tappedIntoActionButton), for: .touchUpInside)
        
        
        cardView.addSubview(actionButtonLogin)
        
        actionButtonLogin.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 197.0 / 343.0 * 1.25).isActive = true
        actionButtonLogin.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        actionButtonLogin.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10.0).isActive = true
        actionButtonLogin.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        actionButtonLogin.layoutIfNeeded()
        actionButtonLogin.addTarget(self, action: #selector(tappedIntoActionButtonLogin), for: .touchUpInside)
        
    }
    
    @objc func tappedIntoActionButton() {
        self.onTapRegister?()
    }
    
    @objc func tappedIntoActionButtonLogin() {
        self.onTapLogin?()
    }
    
}
