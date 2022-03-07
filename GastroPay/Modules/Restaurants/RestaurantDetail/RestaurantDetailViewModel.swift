//
//  RestaurantDetailViewModel.swift
//  Gastropay
//
//  Created by Ramazan Oz on 28.07.2021.
//

import Foundation
import CoreLocation

public class RestaurantDetailViewModel {
    var merchantDetailModel: NetworkModels.MerchantDetailed?
    var merchant: Merchant?

    let restaurantDetailHeaderView: RestaurantDetailHeaderView = RestaurantDetailHeaderView()
    let restaurantDetailTopInfoView: RestaurantDetailTopInfoView = RestaurantDetailTopInfoView()
    let restaurantDetailExpensivityView: RestaurantDetailExpensivityView = RestaurantDetailExpensivityView()
    let navigationButtonView: NavigationButtonView = NavigationButtonView()
    
    var onSetLoadingState: ((Bool) -> ())? = nil

    let googleMapsTitle = Localization.Restaurants.Detail.navigationPopupTitleGoogleMaps.local
    let appleMapsTitle = Localization.Restaurants.Detail.navigationPopupTitleAppleMaps.local
    let yandexMapsTitle = Localization.Restaurants.Detail.navigationPopupTitleYandexMaps.local
    let cancelTitle = Localization.Restaurants.Detail.navigationPopupTitleCancel.local
    
    public init(merchant: Merchant) {
        self.merchant = merchant
    }
    
    func getMerchantDetail(viewController: MIStackableViewControllerWithHeader) {
        guard let merchant = merchant else { return }
        self.onSetLoadingState?(true)
        Service.getAPI()?.getMerchantDetail(merchantUUID: merchant.merchantId) { [weak self] (result) in
            guard let self = self else { return }
            defer { Service.getTabbarController()?.view.setLoadingState(show: false) }
            switch result {
            case .success(let merchantDetailModel):
                self.merchantDetailModel = merchantDetailModel
                self.initViewData(viewController: viewController)
                self.onSetLoadingState?(false)
            case .failure(let error):
                Service.getPopupManager()?.showErrorMessage(error)
            }
        }
    }
    
    func initViewData(viewController: MIStackableViewControllerWithHeader) {
        guard let merchantDetailModel = merchantDetailModel else { return }

        restaurantDetailTopInfoView.initWithMerchantDetailModel(merchantDetailModel)

        viewController.stackView.addArrangedSubview(restaurantDetailTopInfoView)
        restaurantDetailTopInfoView.tagCollectionView.collectionViewLayout.invalidateLayout()

        if let merchantExpensivity = merchantDetailModel.rate {
            restaurantDetailExpensivityView.expensivity = Int(merchantExpensivity)
            viewController.stackView.addArrangedSubview(restaurantDetailExpensivityView)
        }
        
        if (merchantDetailModel.address?.fullAddressText) != nil {
            navigationButtonView.onTapNavigate = {
                self.tappedNavigateButton(viewController: viewController)
            }
            viewController.stackView.addArrangedSubview(navigationButtonView)
        }

        viewController.stackView.arrangedSubviews.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.3) {
            viewController.stackView.arrangedSubviews.forEach { $0.alpha = 1 }
        }
    }
    
    @objc func tappedNavigateButton(viewController: MIStackableViewControllerWithHeader) {
        guard let merchant = merchantDetailModel else { return }
        guard let merchantName = merchant.name, let latitude = merchant.latitude, let longitude = merchant.longitude else { return }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: googleMapsTitle, style: .default) {_ in
            MapHelper.shared.openWithGoogleMap(location: CLLocation(latitude: latitude, longitude: longitude))
        })
        alertController.addAction(UIAlertAction(title: appleMapsTitle, style: .default) {_ in
            MapHelper.shared.openMapWithPoint(locationName: merchantName, location: CLLocation(latitude: latitude, longitude: longitude))
        })
        alertController.addAction(UIAlertAction(title: yandexMapsTitle, style: .default) {_ in
            MapHelper.shared.openYandexNavigation(location: CLLocation(latitude: latitude, longitude: longitude))
        })
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
