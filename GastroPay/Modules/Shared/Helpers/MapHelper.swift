***REMOVED***
***REMOVED***  MapHelper.swift
***REMOVED***  Shared
***REMOVED***
***REMOVED***  Created by Emrah Korkmaz on 11.02.2020.
***REMOVED***  Copyright © 2020 Multinet. All rights reserved.
***REMOVED***

import Foundation
import MapKit

public final class MapHelper {
    public static let shared = MapHelper()

    public func openMapWithPoint(locationName: String, location: CLLocation) {
        let regionSpan = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        let placemark = MKPlacemark(coordinate: location.coordinate)

        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = locationName

        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)
        ])
    }

    public func openMapWithNavigation(from: CLLocation, to: CLLocation) {
        let url = "http:***REMOVED***maps.apple.com/maps?saddr=\(from.coordinate.latitude),\(from.coordinate.longitude)&daddr=\(to.coordinate.latitude),\(to.coordinate.longitude)"
        UIApplication.shared.open(URL(string: url)!)
    }

    public func openWithGoogleMap(location: CLLocation) {
        let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:***REMOVED***")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps:***REMOVED***?center=\(locationString)&zoom=14&q=\(locationString)&views?traffic")!)
        } else {
            let url = URL(string: "http:***REMOVED***maps.google.com/maps?q=@\(locationString)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    public func openYandexNavigation(location: CLLocation) {
        if UIApplication.shared.canOpenURL(URL(string: "yandexmaps:***REMOVED***")!) {
            UIApplication.shared.open(URL(string: "yandexmaps:***REMOVED***maps.yandex.ru/?pt=\(location.coordinate.longitude),\(location.coordinate.latitude)&z=14&l=map")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "https:***REMOVED***maps.yandex.com.tr/?pt=\(location.coordinate.longitude),\(location.coordinate.latitude)&z=14&l=map")!, options: [:], completionHandler: nil)
        }
    }

    private init() {}
}
