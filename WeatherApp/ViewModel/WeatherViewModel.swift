//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 10.8.24.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var hasError = false
    @Published var error: WeatherError?
    
    func fetchWeatherData(place: String) {
        hasError = false
        let url = "https://api.weatherapi.com/v1/current.json?key=9c5f02690a0b45dcbcb133904241008&q=\(place)&aqi=no"
        
        guard let safeUrl = URL(string: url) else {
            self.error = WeatherError.invalidURL
            hasError = true
            return
        }
        
        let weatherTask = URLSession.shared.dataTask(with: safeUrl) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.error = WeatherError.custom(error: error!)
                self?.hasError = true
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let weather = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async { self?.weatherData = weather }
            } catch {
                DispatchQueue.main.async {
                    self?.hasError = true
                    self?.error = WeatherError.failedToDecode
                }
            }
        }
        weatherTask.resume()
    }
}

extension WeatherViewModel {
    enum WeatherError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidCity
        case invalidURL
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Failed to Decode the Data"
            case .custom(let error):
                return error.localizedDescription
            case .invalidCity:
                return "Invalid City Input"
            case .invalidURL:
                return "Invalid URL for Request"
            }
        }
    }
}
