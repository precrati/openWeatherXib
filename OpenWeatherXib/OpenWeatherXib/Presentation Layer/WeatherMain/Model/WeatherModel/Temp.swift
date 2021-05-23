//
//  Temp.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 19/05/2021.
//

import Foundation

struct Temperature: Codable {
    
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
