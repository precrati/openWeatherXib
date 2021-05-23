//
//  WeatherModel.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 18/05/2021.
//

import Foundation

// MARK: - Welcome
struct CurrentWeatherDataModel: Codable {
    
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    var hourly: [Hourly]
    var daily: [Daily]
}
