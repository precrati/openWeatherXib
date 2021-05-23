//
//  ViewController.swift
//  OpenWeatherXib
//
//  Created by Igor Lemeshevski on 18/05/2021.
//

import UIKit

struct WeatherDataModel {
    
    var cityName: String
    var temterature: Int
    var humidity: Int
    var wind: Int
    var pressure: Int
    var daily: [Hourly]
    var weekly: [Daily]
    var isDataLoaded: Bool
}

final class WeatherMainViewController: UIViewController {
    
    // MARK: - Injected Properties
    var output: WeatherMainOutputProtocol?
    
    // MARK: - Private Properties
    var cities: [CitiesModel] = []
    var weekly: [Daily] = [] {
        didSet {
            dailyWeather.reloadData()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var weekWeatherLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var weeklyWeather: WeeklyWeatherView!
    @IBOutlet weak var dailyWeather: UITableView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerDependencies()
        setupLayout()
        registerCells()
        output?.viewIsReady()
    }
    
    
    // MARK: - Private Functions
    private func registerDependencies() {
        let networkManager = NetworkManager()
        let presenter = WeatherMainPresenter(service: networkManager)
        output = presenter
        presenter.view = self
    }
    
    private func setupLayout() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(addTapped))
        dailyWeather.dataSource = self
        dailyWeather.rowHeight = 44
    }
    
    private func showLabels(_ isDataLoaded: Bool) {
        
        dayWeatherLabel.text = isDataLoaded ? "Погода на день" : "Получаем данные..."
        weekWeatherLabel.isHidden = !isDataLoaded
    }
    
    private func registerCells() {
        
        let cell = UINib(nibName: "dailyWeatherCell", bundle: nil)
        dailyWeather.register(cell, forCellReuseIdentifier: "dailyWeatherCell")
    }
    
    @objc func addTapped() {
        
        let optionMenu = UIAlertController(title: nil,
                                           message: "Выберите город",
                                           preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отменить",
                                         style: .cancel)
            
        for city in cities {
            optionMenu.addAction(UIAlertAction(title: city.name,
                                               style: .default) { [weak self] _ in self?.output?.getCityData(city: city) })
        }
        
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - WeatherMainViewController + PresenterInput
extension WeatherMainViewController: WeatherMainInputProtocol {
    
    func showOffline() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Режим Оффлайн", message: "Проверьте ваше подключение к интернету", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.dayWeatherLabel.text = "Режим оффлайн"
        }
    }
    
    func setupData(data: WeatherDataModel) {
        
        DispatchQueue.main.async {
            self.title = data.cityName
            self.currentTemperature.text = "\(data.temterature)°"
            self.humidityLabel.text = "\(data.humidity)%"
            self.pressureLabel.text = String(data.pressure)
            self.windLabel.text = "\(data.wind)м/с"
            self.weekly = data.weekly
            self.weeklyWeather.current = data.daily
            self.showLabels(data.isDataLoaded)
        }
    }
    
    func getCities(cities: [CitiesModel]) {
        
        self.cities = cities
    }
}

// MARK: - WeatherMainViewController + DataSource
extension WeatherMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        weekly.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dailyWeatherCell",
                                                       for: indexPath) as? DailyWeatherCell else { fatalError() }
        cell.configure(data: weekly[indexPath.row])
        return cell
    }
}
