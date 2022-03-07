//
//  CreditCardCompactCell.swift
//  Units
//
//  Created by Emrah Multinet on 9.01.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import Then

public class CreditCardCompactCell: UICollectionViewCell {
    
    private var imageViewContainerView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    private var textContainerView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    public var iconImageView = UIImageView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = false
    }
    
    public var descriptionLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.75
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI(){
        addSubview(imageViewContainerView)
        addSubview(textContainerView)
        
        imageViewContainerView.addSubview(iconImageView)
        textContainerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            imageViewContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            imageViewContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageViewContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageViewContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            
            textContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            textContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textContainerView.topAnchor.constraint(equalTo: topAnchor),
            textContainerView.leftAnchor.constraint(equalTo: imageViewContainerView.rightAnchor, constant: 0),
            
            iconImageView.topAnchor.constraint(equalTo: imageViewContainerView.topAnchor),
            iconImageView.leftAnchor.constraint(equalTo: imageViewContainerView.leftAnchor),
            iconImageView.widthAnchor.constraint(equalTo: imageViewContainerView.widthAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: imageViewContainerView.bottomAnchor),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: textContainerView.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: textContainerView.centerYAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: textContainerView.leftAnchor, constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: textContainerView.rightAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: -5),
            descriptionLabel.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 5)
        ])
    }

    public func configure(campaign: Campaign) {
        iconImageView.setImage(from: campaign.imageUrl)
        let descMessage = campaign.title
        descriptionLabel.text = descMessage
    }
}
