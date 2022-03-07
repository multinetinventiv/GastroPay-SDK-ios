//
//  ImageTextTableCell.swift
//  Profile
//
//  Created by Ufuk Serdogan on 4.03.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit

class ImageTextTableCell: UITableViewCell {

    var leftImage = UIImageView()
    var rightImage = UIImageView()
    var titleLbl = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        leftImage = UIImageView(frame: CGRect.zero)
        contentView.addSubview(leftImage)

        rightImage = UIImageView(frame: CGRect.zero)
        rightImage.image = ImageHelper.Icons.chevronRight
        contentView.addSubview(rightImage)

        titleLbl = UILabel(frame: CGRect.zero)
        titleLbl.font = FontHelper.Profile.cellTitles
        titleLbl.textColor = ColorHelper.Profile.cellTitles
        contentView.addSubview(titleLbl)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftImage.frame = CGRect(x: 10, y: 17, width: 25, height: 25)
        rightImage.frame = CGRect(x: contentView.bounds.width - 25, y: 25, width: 8, height: 13)
        titleLbl.frame = CGRect(x: 45, y: 21, width: contentView.bounds.width - 90, height: 18)

    }

    func setUI(image: UIImage, title: String) {
        self.leftImage.image = image
        self.titleLbl.text = title
    }
}
