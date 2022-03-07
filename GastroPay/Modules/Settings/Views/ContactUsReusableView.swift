//
//  ContactUsReusableView.swift
//  Profile
//
//  Created by Ufuk Serdogan on 4.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

protocol ContactUsReusableViewProtocol {
    func cellTapped(row: Int)
}

enum ProfilePageType {
    case contactUs
    case settings
}

class ContactUsReusableView: UICollectionReusableView {
    let backgroundImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.image = ImageHelper.Profile.contactUsBackground
        $0.clipsToBounds = true
    }

    let headerContentView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var delegate: ContactUsReusableViewProtocol?
    var pageType: ProfilePageType = .contactUs {
        didSet{
            initUI()
            self.setUIForPageType()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    func initUI(){
        var height: CGFloat
        switch self.pageType {
        case .contactUs:
            height = 60.0
        case .settings:
            height = 240.0
        }
        //Header View
        headerContentView.layer.applySketchShadow(color: UIColor.lightGray, alpha: 0.5, x: 0, y: 3, blur: 8, spread: 0, cornerRadius: 0)
        addSubview(headerContentView)

        let horizontalConstraint = headerContentView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let widthConstraint = headerContentView.widthAnchor.constraint(equalToConstant: self.bounds.width - 40)
        let heightConstraint = headerContentView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        let bottomConstraint = headerContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        self.addConstraints([horizontalConstraint,widthConstraint,heightConstraint,bottomConstraint])
    }

    private func initBackgroundImage() {
        var height: CGFloat

        switch self.pageType {
        case .contactUs:
            height = -60
        case .settings:
            height = -180
        }
        
        self.backgroundImageView.image = ImageHelper.Profile.contactUsBackground

        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)

        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: CGFloat(height)).isActive = true
    }

    public func setUIForPageType(){
        initBackgroundImage()

        let contactHeaderView = ContactUsHeaderView()
        switch self.pageType {
        case .contactUs:
            contactHeaderView.pageType = .contactUs
        case .settings:
            contactHeaderView.pageType = .settings
        }
        headerContentView.addSubview(contactHeaderView)
        contactHeaderView.translatesAutoresizingMaskIntoConstraints = false
        contactHeaderView.topAnchor.constraint(equalTo: headerContentView.topAnchor).isActive = true
        contactHeaderView.bottomAnchor.constraint(equalTo: headerContentView.bottomAnchor).isActive = true
        contactHeaderView.leadingAnchor.constraint(equalTo: headerContentView.leadingAnchor).isActive = true
        contactHeaderView.trailingAnchor.constraint(equalTo: headerContentView.trailingAnchor).isActive = true
        contactHeaderView.delegate = self
    }
}

extension ContactUsReusableView: ContactUsHeaderViewProtocol {
    func cellTapped(row: Int) {
        self.delegate?.cellTapped(row: row)
    }
}
