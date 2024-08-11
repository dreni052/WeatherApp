//
//  UsersLocalisation.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 11.8.24.
//

import SwiftUI
import CoreLocation

class UserLocalisationVm: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentCity: String = "Unknown"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCityAndRegion(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func fetchCityAndRegion(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error getting city and region name: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.currentCity = "Unknown"
                }
                return
            }
            
            if let placemark = placemarks?.last {
                DispatchQueue.main.async {
                    self.currentCity = placemark.locality ?? "Unknown"
                    print(placemark.locality!)
                }
            } else {
                DispatchQueue.main.async {
                    self.currentCity = "Unknown"
                }
            }
        }
    }
}
