//
//  WeatherPresenter.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 18/05/2021.
//

import Foundation
import CoreData
import UIKit

final class WeatherMainPresenter {
    
    weak var view: WeatherMainInputProtocol?
    var service: NetworkManager?
    var baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var cities: [CitiesModel] = [CitiesModel(name: "Москва", lat: 55.751244, long: 37.618423),
                                 CitiesModel(name: "Торонто", lat: 43.651070, long: -79.347015),
                                 CitiesModel(name: "Ярославль", lat: 57.6299, long: 39.8737),
                                 CitiesModel(name: "Лондон", lat: 51.509865, long: -0.118092)]
    
    init(service: NetworkManager) {
        
        self.service = service
    }
    
    private func deleteAllData(entity: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    private func coreDataSaveContent(city: String,
                                     humidity: Int64,
                                     pressure: Int64,
                                     temperature: Int64,
                                     wind: Double) {
        
        guard let context = context, let entity = NSEntityDescription.entity(forEntityName: "CityWeather", in: context) else { return }
        let cityObject = CityWeather(entity: entity, insertInto: context)
        cityObject.city = city
        cityObject.humidity = humidity
        cityObject.pressure = pressure
        cityObject.temperature = temperature
        cityObject.wind = wind
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func coreDataFetch() -> [CityWeather] {
        
        guard let context = context else { return [] }
        let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    private func firstOpenLoad() {
        
        guard let firstCity = cities.first else { return }
        if !coreDataFetch().isEmpty {
            let model = coreDataFetch().first
            let sendData = WeatherDataModel(cityName: (model?.city)!, temterature: Int((model?.temperature)!), humidity: Int((model?.humidity)!), wind: Int((model?.wind)!), pressure: Int((model?.pressure)!), daily: [], weekly: [], isDataLoaded: false)
            self.view?.setupData(data: sendData)
            getWeatherData(city: firstCity)
        } else {
            getWeatherData(city: firstCity)
        }
    }
    
    private func showOffline() {
        
        view?.showOffline()
    }
    
    private func getWeatherData(city: CitiesModel) {
        
        service?.request(url: baseUrl,
                         parameters: ["lat": "\(city.lat)", "lon": "\(city.long)", "units": "metric", "appid": "542ffd081e67f4512b705f89d2a611b2"],
                         type: CurrentWeatherDataModel.self) { [weak self] (weather, error) in
            if let error = error {
                self?.showOffline()
                print(error)
            }
            guard let dataLoaded: CurrentWeatherDataModel = weather else { return }
            let sendData: WeatherDataModel = WeatherDataModel(cityName: city.name, temterature: Int(dataLoaded.current.temp), humidity: dataLoaded.current.humidity, wind: Int(dataLoaded.current.windSpeed), pressure: dataLoaded.current.pressure, daily: dataLoaded.hourly, weekly: dataLoaded.daily, isDataLoaded: true)
            DispatchQueue.main.async {
                self?.deleteAllData(entity: "CityWeather")
            }
            self?.coreDataSaveContent(city: city.name, humidity: Int64(dataLoaded.current.humidity), pressure: Int64(dataLoaded.current.pressure), temperature: Int64(dataLoaded.current.temp), wind: dataLoaded.current.windSpeed)
            
            self?.view?.setupData(data: sendData)
        }
    }
}

extension WeatherMainPresenter: WeatherMainOutputProtocol {
    
    func getCityData(city: CitiesModel) {
        getWeatherData(city: city)
    }
    
    func viewIsReady() {
        firstOpenLoad()
        view?.getCities(cities: cities)
    }
}
