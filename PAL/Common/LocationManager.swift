//
//  LocationManager.swift
//  Specialz
//
//  Created by i-Phone on 4/30/19.
//  Copyright © 2019 i-Verve. All rights reserved.
//

import MapKit

class LocationManager: NSObject {
    
    // MARK: - Variables
    static let shared = LocationManager()
    private var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CustomMethods
    func askForPermission() -> Void {
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationServiceStatus() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
             default:
                return false
            }
        } else {
            print("Location services are not enabled")
        }
         return false
    }
    
    func startUpdatingLocation() -> Void {
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingLocation() -> Void {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
//        print("AppDelegatre_locations = \(locValue.latitude) \(locValue.longitude)")
                
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        print("Location Update error")
    }
}
