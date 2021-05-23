//
//  Daily.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import Foundation

struct Daily: Codable {
    
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let clouds: Int
    let uvi: Double
    
    private enum CodingKeys : String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, uvi
    }
}
