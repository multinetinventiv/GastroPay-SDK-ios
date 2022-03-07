//
//  ProfileCollectionCell.swift
//  Profile
//
//  Created by Ufuk Serdogan on 2.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

class ProfileCollectionCell: UICollectionViewCell {
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rihtImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var baseContentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.rihtImage.image = ImageHelper.Icons.chevronRight
        self.titleLbl.font = FontHelper.Profile.cellTitles
        self.titleLbl.textColor = ColorHelper.Profile.cellTitles
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        baseContentView.layer.shadowOpacity = 0.4
        baseContentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        baseContentView.layer.shadowRadius = 4.0
        let shadowRect: CGRect = baseContentView.bounds.insetBy(dx: 0, dy: 4)
        baseContentView.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.seperatorView.alpha = 0.3
    }

    func setupUI(image: UIImage, title: String) {
        self.leftImage.image = image
        self.titleLbl.text = title
    }

    func setupForEmptyCell() {
        self.titleLbl.isHidden = true
        self.leftImage.isHidden = true
        self.rihtImage.isHidden = true
        self.baseContentView.isHidden = true
    }
}
