//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 10.8.24.
//
// This is the ViewModel part of the app
// which makes the API call to receive the data and handle them to show it to the user

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var hasError = false
    @Published var error: WeatherError?
    
    func fetchWeatherData(place: String) {
        hasError = false
        let url = "https://api.weatherapi.com/v1/current.json?key=9c5f02690a0b45dcbcb133904241008&q=\(place)&aqi=no"
        // Here is the URL with a string interpolation "q=\(place)", when we call the function we fetch the city name
        // in the (place: String) parameter of the function and make an API call modified through that String
        
        // We safely unwrap the URL to check if the URL is valid for use
        // else we throw an error and show the User that the URL used is not valid
        guard let safeUrl = URL(string: url) else {
            self.error = WeatherError.invalidURL
            hasError = true
            return
        }
        
        // We use here URLSession which is used to make the API call and returns three type of response as seen below
        let weatherTask = URLSession.shared.dataTask(with: safeUrl) { [weak self] data, response, error in
        // We check for the feedback of the URL Request, check if data exist and check if it has any error
        // else we throw a custom error to the user letinng him know what is wrong with the Request
            guard let data = data, error == nil else {
                self?.error = WeatherError.custom(error: error!)
                self?.hasError = true
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        // We use the code above to convert the JSON Data to usable Swift Model for better/cleaner code
        // an example of .convertingFromSnakeCase: Before(temp_c) After(tempC)
            
        // In this do/catch block we try to decode the data given from the request
        // and assign that data decoded to the @Published property so that it has live updates aka we can Observe the Changes
        // else we throw an Error to the user which it displays the message: Failed to Decode the Data given
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
// weatherTask which we declared on line 32 which is the URL Request
// is used with the .resume() modifier to kick of the URL Request

// This extension holds all the error cases with a message to return
// to fetch to the user as Humane as possible the error so that the User can understand easily
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
