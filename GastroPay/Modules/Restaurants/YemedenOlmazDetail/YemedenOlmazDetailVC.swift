//
//  YemedenOlmazDetailVC.swift
//  Restaurants
//
//  Created by Emrah Korkmaz on 7.02.2020.
//  Copyright © 2020 Multinet. All rights reserved.
//

import UIKit
import YPNavigationBarTransition
import Then

public class YemedenOlmazDetailVC: MIViewController, NavigationBarConfigureStyle{
    
    public var viewModel: YemedenOlmazViewModel!
    
    var gradientProgress: CGFloat = 0.0
    
    var navigationBarGradientProgress: CGFloat = 0
    
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        var configuration: YPNavigationBarConfigurations = .backgroundStyleColor

        if gradientProgress == 1 {
            configuration = .backgroundStyleOpaque
        }

        titleLabel.textColor = UIColor(white: 0, alpha: gradientProgress)

        return configuration
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        return UIColor(white: 1.0 - gradientProgress, alpha: 1.0)
    }

    public func yp_navigationBackgroundColor() -> UIColor! {
        return UIColor(white: 1.0, alpha: gradientProgress)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .clear
        $0.text = Localization.Campaigns.navigationTitle.local
        $0.font = FontHelper.Navigation.title
    }
    
    public var collectionView: MIDynamicHeightCollectionView!
    
    public init(viewModel: YemedenOlmazViewModel){
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
    }
    
    private func setUI(){
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: ImageHelper.Icons.close, style: .done, target: self, action: #selector(onTapActionButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        let collectionViewFlowLayout = UICollectionViewStretchyHeaderLayout()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView = MIDynamicHeightCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(YemedenOlmazDetailCell.self)
        collectionView.registerSupplementaryViewHeader(YemedenOlmazDetailHeaderView.self)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func onTapActionButton(){
        self.navigationController?.popViewController(animated: true)
    }
        
}


extension YemedenOlmazDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(YemedenOlmazDetailCell.self, for: indexPath)
        cell.setDetail(mealTitle: viewModel.yemedenOlmazTitle, mealDescription: viewModel.yemedenOlmazDescription)
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryViewHeader(YemedenOlmazDetailHeaderView.self, for: indexPath)
        headerView.restaurantTitle.text = viewModel.restaurantName
        if let headerIconUrl = viewModel.restaurantIconUrl {
            headerView.restaurantIconImage.setImage(from: headerIconUrl)
        }
        if let backgroundImage = viewModel.backgroundImageUrl {
            headerView.backgroundImage.setImage(from: backgroundImage)
        }
        return headerView
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2 - 10)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let descriptionText = viewModel.yemedenOlmazDescription ?? ""
        
        let size = CGSize(width: self.view.frame.width - 57 , height: 1000)
        
        let attributes = [NSAttributedString.Key.font: FontHelper.Restaurants.Detail.mealDescription]
        let rectangle = NSString(string: descriptionText).boundingRect(with: size,
                                                                       options: .usesLineFragmentOrigin,
                                                                       attributes: attributes,
                                                                       context: nil)
        
        let height = collectionView.frame.height
        
        return CGSize(width: self.view.frame.width, height: rectangle.height + height)
    }
}
