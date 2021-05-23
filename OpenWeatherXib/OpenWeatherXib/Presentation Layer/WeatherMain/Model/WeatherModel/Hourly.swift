//
//  Hourly.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 20/05/2021.
//

import Foundation

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let clouds: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    
    private enum CodingKeys : String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}
