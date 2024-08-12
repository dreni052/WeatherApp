//
//  UsersLocalisation.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 11.8.24.
//

import SwiftUI
import CoreLocation

// We import the CoreLocation and conform to the LocationManagerDelegate to get the user location
class UserLocalisationVm: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentCity: String = "Unknown"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    // locationManager that conforms to CLLocationManager is set with the delegate
    // which handles location updates, errors, status etc to self so it handles location updates
    
    // this function is from the CLLocationManagerDelegate protocol which is used to receive the users
    // coordinates if they are allowed and calls the fetchCity functions which passes the coordinates to locate the city
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCityAndRegion(from: location)
    }
    
    // This functions here handles the error if there is one and prints it with a more detailed version
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // this function takes an input which is CLLocation and uses CLGeocoder with reverseGeocodeLocation
    // modifier to get the placemarks of that coordinates which shows the city, country, nearby places and others
    func fetchCityAndRegion(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Error getting city and region name: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.currentCity = "Unknown"
                }
                return
            }
            // here we handle the error in case there is one
            
            // here we unwrap the placemark location and
            // assign that value to currentCity label if there is an a response
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
