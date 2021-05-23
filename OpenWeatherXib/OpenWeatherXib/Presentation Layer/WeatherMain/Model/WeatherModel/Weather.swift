//
//  Weather.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    
    let id: Int
    let main: String
    let description: String
    let icon: String
}
