//
//  WeatherViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var weatherTableView: UITableView!
    
    // MARK: - Variables
    private var weatherService: WeatherService!
    private var data: [WeatherStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherService = WeatherService(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherService.fetchForCities(cities: ["Paris", "New York", "Berlin", "La Rochelle"])
    }
}

// MARK: - WeatherServiceDelegate
extension WeatherViewController: WeatherServiceDelegate {
    
    func didFinish(result: [WeatherStruct]) {
        self.data = result
        
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
}

class MeteoCell: UITableViewCell {

    @IBOutlet private weak var meteoImage: UIImageView!
    @IBOutlet private weak var meteoTemperature: UILabel!
    @IBOutlet private weak var meteoLabel: UILabel!
    
    func configure(image: UIImage?, temperature: String, city: String) {
        self.meteoLabel.text = city
        self.meteoTemperature.text = temperature
        self.meteoImage.image = image
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoCityCell",
                                                 for: indexPath) as! MeteoCell
        
        let cityModel = self.data[indexPath.row]
        
        cell.configure(image: UIImage(named: cityModel.weather.first?.icon ?? ""),
                       temperature: "\(cityModel.main.temp) °C",
                       city: "\(cityModel.name)")
        
        return cell
    }
}
