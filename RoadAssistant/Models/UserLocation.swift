//
//  UserLocation.swift
//  RoadAssistant
//
//  Created by Youssif Hany on 09/03/2022.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject{
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    func requstLocation(){
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .notDetermined:
            print("Debug: not determined")
        case .restricted:
            print("Debug: restricted")
        case .denied:
            print("Debug: denied")
        case .authorizedAlways:
            print("Debug: auth always")
        case .authorizedWhenInUse:
            print("Debug: authorized When In Use")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        self.userLocation = location
    }
}
