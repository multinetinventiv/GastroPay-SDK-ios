***REMOVED***
***REMOVED***  TopBarView.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 29.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public class TopBarView: UIView {
    var onTappedSettings: (() -> ())?
    var onTappedClose: (() -> ())?
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(red: 39/255, green: 60/255, blue: 47/255, alpha: 1.0)
        addSubview(backgroundView)
        backgroundView.heightAnchor.constraint(equalToConstant: 68.0 + UIApplication.shared.statusBarFrame.size.height).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = UIColor(red: 39/255, green: 60/255, blue: 47/255, alpha: 1.0)
        
        addSubview(circleView)
        circleView.heightAnchor.constraint(equalToConstant: 96.0).isActive = true
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 96.0).isActive = true
        circleView.layoutIfNeeded()
        circleView.layer.cornerRadius = circleView.frame.width / 2
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(imageView)

        imageView.image = ImageHelper.General.logo

        imageView.contentMode = .scaleAspectFit
        imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -18).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 52.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 96.0).isActive = true
        
        let settingsButton = UIButton()
        settingsButton.addTarget(self, action: #selector(tappedSettings), for: .touchUpInside)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(settingsButton)
        
        settingsButton.setImage(ImageHelper.Profile.settings, for: .normal)

        settingsButton.contentMode = .scaleAspectFit
        settingsButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -17).isActive = true
        settingsButton.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
     
        let closeButton = UIButton()
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(tappedClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(closeButton)
        
        closeButton.setImage(ImageHelper.Icons.close, for: .normal)

        closeButton.contentMode = .scaleAspectFit
        closeButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -23).isActive = true
        closeButton.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -18).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 14.0).isActive = true
    }
    
    @objc func tappedSettings() {
        onTappedSettings?()
    }
    
    @objc func tappedClose() {
        onTappedClose?()
    }
}
