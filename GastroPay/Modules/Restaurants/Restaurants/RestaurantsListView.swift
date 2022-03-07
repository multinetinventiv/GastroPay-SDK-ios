//
//  RestaurantsEarnCollectionView.swift
//  Restaurants
//
//  Created by  on 30.10.2019.
//  Copyright © 2019 Multinet. All rights reserved.
//

import UIKit
import CoreLocation

public class RestaurantsListView: UIView {
    private let footerView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var collectionView: UICollectionView = {
        let cvFlowLayout = UICollectionViewFlowLayout()
        cvFlowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cvFlowLayout)
        cv.register(MerchantsCloseToMeCollectionViewCell.self)
        cv.register(RestaurantListViewPaginationFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RestaurantListViewPaginationFooter.reuseIdentifier)
        (cv.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: cv.bounds.width, height: 50)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return cv
    }()

    let locationRequestView = MerchantsCloseToMeUnauthorizedState(showTitle: false).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var restaurantManager: RestaurantManager?

    var onSelectMerchant: ((_ merchant: Merchant?) -> Void)?
    var onSetLoadingIndicator: ((Bool) -> ())?

    init(restaurantManager: RestaurantManager?) {
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationAuthChanged(notification:)), name: LocationManager.Notifications.LocationAuthorizationChanged, object: nil)
        
        MIServiceBus.onMainThread(self, name: MIEventHelper.RefreshRestaurantLists) {[weak self] (notification) in
            guard let self = self else { return }
            if (Service.getLocationManager()?.isAuthorized()) ?? false, restaurantManager?.getOrInitRestaurants() == nil {
                self.onSetLoadingIndicator?(true)
            }
        }
        
        self.restaurantManager = restaurantManager
        restaurantManager?.addDelegate(self)
        
        if !(Service.getLocationManager()?.isAuthorized() ?? false) {
            initLocationRequestView()
        } else {
            if restaurantManager?.getOrInitRestaurants() == nil {
                self.onSetLoadingIndicator?(true)
            }
            
            initCollectionView()
        }
    }
    
    @objc func locationAuthChanged(notification: NSNotification) {
        if let authorizationStatus = notification.userInfo?[LocationManager.NotificationKeys.AuthorizationState] as? LocationAuthorizationStatus, authorizationStatus == .authorizedWhenInUse {
            if restaurantManager?.getOrInitRestaurants() == nil {
                self.onSetLoadingIndicator?(true)
            }
            
            initCollectionView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLocationRequestView() {
        addSubview(locationRequestView)
        NSLayoutConstraint.activate([
            locationRequestView.topAnchor.constraint(equalTo: topAnchor),
            locationRequestView.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationRequestView.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationRequestView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        locationRequestView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRequestLocation)))
    }

    func initCollectionView() {
        if locationRequestView.superview != nil {
            locationRequestView.removeFromSuperview()
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        collectionView.bindFrameToSuperviewBounds()
    }

    @objc func tappedRequestLocation() {
        if Service.getLocationManager()?.isDenied() ?? false || !(Service.getLocationManager()?.isLocationServicesEnabled() ?? false) {
            Service.getPopupManager()?.openLocationAuthorizationDeniedPopup()
            return
        }

        Service.getLocationManager()?.requestWhenInUseAuthentication()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RestaurantsListView: RestaurantManagerDelegate {
    public func restaurantManager(didUpdateRestaurants restaurants: [Merchant]) {
        self.collectionView.reloadData()
        self.footerView.stopAnimating()

        self.onSetLoadingIndicator?(false)
    }
    
    public func restaurantManagerRequestCancelled() {
        self.footerView.stopAnimating()

        self.onSetLoadingIndicator?(false)
    }
}

extension RestaurantsListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (restaurantManager?.getRestaurants().count ?? 0) - 1, !footerView.isAnimating, !(restaurantManager?.isEndOfPagination ?? false) {
                footerView.startAnimating()
            restaurantManager?.fetchNextRestaurants(isForNextPage: true)
            Service.getLogger()?.debug("Restaurant fetchNextRestaurants started for pagination")
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: restaurantManager?.isEndOfPagination ?? true ? 0 : 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RestaurantListViewPaginationFooter.reuseIdentifier, for: indexPath)
                footerView.removeFromSuperview()
                footer.addSubview(footerView)
                footerView.bindFrameToSuperviewBounds()
                return footer
            }
            return UICollectionReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantManager?.getRestaurants().count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MerchantsCloseToMeCollectionViewCell.self, for: indexPath)
        let merchants = restaurantManager?.getRestaurants()
        if (merchants?.indices.contains(indexPath.item)) ?? false, let merchant = merchants?[indexPath.item] {
            cell.configure(for: merchant)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32.0
        let height = width * 195 / 343
        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelectMerchant?(restaurantManager?.getRestaurants()[safeIndex: indexPath.item])
    }
}
