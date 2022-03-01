***REMOVED***
***REMOVED***  RestaurantInfo.swift
***REMOVED***  Restaurants
***REMOVED***
***REMOVED***  Created by  on 22.09.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import UIKit
import Then
import AlignedCollectionViewFlowLayout

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: self],
                                                     context: nil).size
    }
}

class RestaurantDetailTopInfoView: UIView {
    var merchantDetailModel: NetworkModels.MerchantDetailed?

    let logoImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.heightAnchor.constraint(equalToConstant: 35).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 35).isActive = true
        $0.layer.cornerRadius = 17.5
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }

    let merchantNameLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 3
        $0.lineBreakMode = .byTruncatingTail
        $0.adjustsFontSizeToFitWidth = true
        $0.font = FontHelper.mediumTextFont(size: 15)
        $0.baselineAdjustment = .none
        $0.minimumScaleFactor = 0.5
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.required, for: .vertical)
        $0.textColor = ColorHelper.activeColor
    }

    let locationLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.regularTextFont(size: 15)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.textColor = ColorHelper.activeColor
    }

    let phoneIcon = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.image = ImageHelper.Icons.phone
        $0.widthAnchor.constraint(equalToConstant: 15).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    let phoneLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.regularTextFont(size: 15)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.textColor = ColorHelper.activeColor
    }

    let tagCollectionView = MIStackCollectionView(frame: .zero, collectionViewLayout: AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)).then {
        ($0.collectionViewLayout as? AlignedCollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(RestaurantTagCell.self)
        $0.backgroundColor = .none
    }

    func initWithMerchantDetailModel(_ merchant: NetworkModels.MerchantDetailed) {
        self.merchantDetailModel = merchant
        initViews(merchant)
        initMerchantData(merchant)
    }

    func initMerchantData(_ merchant: NetworkModels.MerchantDetailed) {
        if let logoImageUrl = merchant.logoUrl {
            logoImageView.setImage(from: logoImageUrl)
        }

        merchantNameLabel.text = merchant.name

        for fontSize in 16...30 {
            let newFont = FontHelper.mediumTextFont(size: CGFloat(fontSize))
            let fontSize = newFont.sizeOfString(string: merchant.name ?? "", constrainedToWidth: Double(UIScreen.main.bounds.width - 63))
            let lineCount = round(fontSize.height / newFont.lineHeight)
            if lineCount == 1 {
                merchantNameLabel.font = newFont
            } else {
                break
            }
        }

        if let merchantCity = merchant.address?.city, let merchantNeighbourhood = merchant.address?.neighbourhood {
            locationLabel.text = "\(merchantCity), \(merchantNeighbourhood)"
        }

        phoneLabel.text = (merchant.phoneNumber ?? merchant.gsmNumber)?.formatNumbers()
    }

    func initViews(_ merchant: NetworkModels.MerchantDetailed) {
        let nameStackRow = UIStackView(arrangedSubviews: [logoImageView, merchantNameLabel])
        nameStackRow.axis = .horizontal
        nameStackRow.alignment = .center
        nameStackRow.spacing = 6
        
        let phoneStackRow = UIStackView(arrangedSubviews: [phoneIcon, phoneLabel])
        phoneStackRow.axis = .horizontal
        phoneStackRow.alignment = .center
        phoneStackRow.spacing = 11

        var containerStackViewSubviews: [UIView] = [locationLabel, phoneStackRow]
        
        if (merchantDetailModel?.tags?.count ?? 0) > 0 {
            containerStackViewSubviews.append(tagCollectionView)
            tagCollectionView.dataSource = self
            tagCollectionView.delegate = self
        }

        let containerStackView = UIStackView(arrangedSubviews: containerStackViewSubviews).then {
            $0.axis = .vertical
            $0.spacing = 16
        }
        
        addSubview(nameStackRow)
        addSubview(containerStackView)

        nameStackRow.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(9)
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right).offset(-16)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(nameStackRow.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(12)
            make.right.equalTo(self.snp.right).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        }

        phoneStackRow.isUserInteractionEnabled = true
        phoneStackRow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedPhoneStack)))
    }

    @objc func tappedPhoneStack() {
        let phoneNumber = (merchantDetailModel?.phoneNumber ?? merchantDetailModel?.gsmNumber)?.formatNumbers()

        if let phoneNumber = phoneNumber,
           let url = URL(string: "tel:***REMOVED***\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}

extension RestaurantDetailTopInfoView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchantDetailModel?.tags?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(RestaurantTagCell.self, for: indexPath)
        cell.tagLabel.text = merchantDetailModel?.tags?[indexPath.item % (merchantDetailModel?.tags?.count ?? 0)].tagName
        return cell
    }

}

public class RestaurantTagCell: UICollectionViewCell{

    let tagLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = FontHelper.Restaurants.Detail.tag
        $0.textColor = ColorHelper.activeColor
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = ColorHelper.Restaurant.Detail.tagBackground

        contentView.addSubview(tagLabel)
        tagLabel.bindFrameToSuperviewBounds(lefMargin: 12, rightMargin: 12, topMargin: 8, bottomMargin: 8)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = contentView.frame.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
