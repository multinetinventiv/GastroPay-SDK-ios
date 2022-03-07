//
//  LocationManager.swift
//  Inventiv+CommonModule
//
//  Created by  on 25.12.2019.
//

import Foundation
import CoreLocation
import UserNotifications

public typealias LocationAuthorizationStatus = CLAuthorizationStatus

public protocol LocationManagerDelegate: AnyObject {
    var listeningLocationUpdates: Bool { get }
    func locationManager(didUpdateLocation location: CLLocation)
}

public class LocationManager: NSObject {
    public struct Notifications {
        public static let LocationAuthorizationChanged = Notification.Name(rawValue: "LocationAuthorizationChanged")
    }

    public struct NotificationKeys {
        public static let AuthorizationState = "AuthorizationState"
    }

    let locationManager: CLLocationManager = CLLocationManager()

    private var _delegates = [LocationManagerDelegate]()

    public var lastLocation: CLLocation?

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    public func isAuthorized() -> Bool {
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        let locationAuthorized = CLLocationManager.authorizationStatus() == .authorizedAlways ||  CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        return locationServicesEnabled && locationAuthorized
    }

    public func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    public func isDenied() -> Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }

    public func requestWhenInUseAuthentication() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func requestAlwaysAuthentication() {
        locationManager.requestAlwaysAuthorization()
    }

    public func startListeningLocationEvents() {
        var shouldStartLocationUpdates = false

        for delegate in _delegates {
            if delegate.listeningLocationUpdates {
                shouldStartLocationUpdates = true
            }
        }

        if shouldStartLocationUpdates {
            locationManager.startUpdatingLocation()
        }
    }

    public func stopListeningLocationEvents() {
        var shouldStopLocationUpdates = true

        for delegate in _delegates {
            if delegate.listeningLocationUpdates {
                shouldStopLocationUpdates = false
            }
        }

        if shouldStopLocationUpdates {
            locationManager.stopUpdatingLocation()
        }
    }

    public func addDelegate(_ delegate: LocationManagerDelegate) {
        self._delegates.append(delegate)
    }

    public func removeDelegate(_ delegate: LocationManagerDelegate) {
        if let index = _delegates.firstIndex(where: { $0 === delegate }) {
            _delegates.remove(at: index)
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: Notifications.LocationAuthorizationChanged, object: nil, userInfo: [
            NotificationKeys.AuthorizationState: status
        ])
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        self.lastLocation = userLocation
        for delegate in _delegates where delegate.listeningLocationUpdates {
            delegate.locationManager(didUpdateLocation: userLocation)
        }
    }

}
