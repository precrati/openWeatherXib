//
//  WeatherMainIO.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 18/05/2021.
//

import Foundation

protocol WeatherMainOutputProtocol: AnyObject {
    
    func viewIsReady()
    func getCityData(city: CitiesModel)
}

protocol WeatherMainInputProtocol: AnyObject {
    
    func getCities(cities: [CitiesModel])
    func setupData(data: WeatherDataModel)
    func showOffline()
}
