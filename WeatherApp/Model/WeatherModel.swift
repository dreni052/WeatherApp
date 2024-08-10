//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Dren Uruqi on 10.8.24.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

struct Current: Codable {
    let lastUpdated: String
    let tempC: Double
    let isDay: Int
    let condition: Condition
    let windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMb: Double
    let pressureIn: Double
    let precipMm: Double
    let precipIn: Double
    let humidity: Int
    let cloud: Int
    let feelslikeC: Double
    let windchillC: Double
    let heatindexC: Double
    let dewpointC: Double
    let visKm: Double
    let uv: Double
    let gustKph: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}
