//
//  RestaurantView.swift
//  Gastropay
//
//  Created by Ramazan Oz on 14.06.2021.
//

import Foundation

public class RestaurantView: UIView {
    var onTappedSearch: (() -> ())?
    var onSelectMerchant: ((Merchant?) -> Void)? {
        didSet { restaurantList?.onSelectMerchant = onSelectMerchant }
    }
    
    var onTappedClose: (() -> ())? {
        didSet { topBarView.onTappedClose = onTappedClose }
    }
    
    var onTappedSettings: (() -> ())? {
        didSet { topBarView.onTappedSettings = onTappedSettings }
    }

    var onSetLoadingIndicator: ((Bool) -> ())? {
        didSet {
            restaurantList?.onSetLoadingIndicator = onSetLoadingIndicator
        }
    }

    var topBarView: TopBarView = {
        let topBarView = TopBarView()
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        return topBarView
    }()
    
    var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var closeLabel: UILabel = {
        let closeLabel = UILabel()
        closeLabel.translatesAutoresizingMaskIntoConstraints = false
        return closeLabel
    }()
    
    var searchIcon: UIImageView = {
        let searchIcon = UIImageView()
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.isUserInteractionEnabled = true
        return searchIcon
    }()
    
    public var restaurantList: RestaurantsListView?
        
    public init(restaurantManager: RestaurantManager?) {
        super.init(frame: .zero)

        restaurantList = RestaurantsListView(restaurantManager: restaurantManager)
        initTopBarView()
        initHeaderView()
        initRestaurantList()
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTopBarView() {
        addSubview(topBarView)
        topBarView.heightAnchor.constraint(equalToConstant: 88.0 + UIApplication.shared.statusBarFrame.size.height).isActive = true
        topBarView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topBarView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func initHeaderView() {
        addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        headerView.addSubview(closeLabel)
        headerView.addSubview(searchIcon)
                
        closeLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        closeLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        closeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16.0).isActive = true
        closeLabel.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant: -16).isActive = true

        searchIcon.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 19).isActive = true
        searchIcon.heightAnchor.constraint(equalToConstant: 19).isActive = true
        searchIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20.0).isActive = true
        
        searchIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedSearch)))
    }
    
    func initRestaurantList() {
        if let restaurantList = restaurantList {
            addSubview(restaurantList)
            restaurantList.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom).offset(8)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.bottom.equalTo(self.snp.bottom)
            }
        }
    }
    
    @objc func tappedSearch() {
        onTappedSearch?()
    }
}
