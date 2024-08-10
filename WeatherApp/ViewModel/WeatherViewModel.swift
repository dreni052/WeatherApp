//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 10.8.24.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    
    func fetchWeatherData(place: String) {
        let url = "https://api.weatherapi.com/v1/current.json?key=9c5f02690a0b45dcbcb133904241008&q=\(place)&aqi=no"
        
        guard let safeUrl = URL(string: url) else {
            return print("invalid URL")
        }
        
        let weatherTask = URLSession.shared.dataTask(with: safeUrl) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print("Valid URL, going to decoding")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let weather = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async { self?.weatherData = weather }
                print(self?.weatherData?.location.name ?? "!")
            } catch {
                print("Failed to decode the data given")
            }
        }
        weatherTask.resume()
    }
}
