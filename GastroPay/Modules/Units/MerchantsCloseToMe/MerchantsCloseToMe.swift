***REMOVED***
***REMOVED***  MerchantsClose.swift
***REMOVED***  Units
***REMOVED***
***REMOVED***  Created by  on 17.10.2019.
***REMOVED***  Copyright © 2019 Multinet. All rights reserved.
***REMOVED***

import UIKit

public protocol MerchantsCloseToMeProtocol {
    func tappedRequestLocationPermission()
    func tappedRestaurant(restaurant: Merchant)
}

public class MerchantsCloseToMe: UIView {
    public var delegate: MerchantsCloseToMeProtocol?

    public var showUnitTitle: Bool = true

    var authorizedStateView: MerchantsCloseToMeAuthorizedState?
    var notAuthorizedStateView: MerchantsCloseToMeUnauthorizedState?

    var locationGestureRecognizer: UITapGestureRecognizer?

    public var merchants: [Merchant]? {
        didSet {
            if authorizedStateView == nil || authorizedStateView != nil && !authorizedStateView!.isDescendant(of: self) {
                initAuthorizedState()
            }
            authorizedStateView?.merchants = self.merchants
        }
    }

    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        initViews()
    }

    func initViews() {
        if ((Service.getLocationManager()?.isAuthorized()) != nil) {
            initAuthorizedState()
        } else {
            initNotAuthorizedState()
        }
    }

    public func initAuthorizedState() {
        if notAuthorizedStateView != nil {
            notAuthorizedStateView!.removeFromSuperview()
            if let locationGestureRecognizer = locationGestureRecognizer {
                self.removeGestureRecognizer(locationGestureRecognizer)
            }
            notAuthorizedStateView = nil
        }

        authorizedStateView = MerchantsCloseToMeAuthorizedState().then {[weak self] in
            guard let self = self else { return }
            $0.delegate = self.delegate
        }
        authorizedStateView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorizedStateView!)
        authorizedStateView!.bindFrameToSuperviewBounds()
    }

    public func initNotAuthorizedState() {
        if authorizedStateView != nil {
            authorizedStateView!.removeFromSuperview()
            authorizedStateView = nil
        }

        notAuthorizedStateView = MerchantsCloseToMeUnauthorizedState(showTitle: showUnitTitle)
        notAuthorizedStateView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notAuthorizedStateView!)
        notAuthorizedStateView!.bindFrameToSuperviewBounds()
        self.locationGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedRequestLocation))
        self.addGestureRecognizer(self.locationGestureRecognizer!)
    }

    @objc func tappedRequestLocation() {
        delegate?.tappedRequestLocationPermission()
    }

}
