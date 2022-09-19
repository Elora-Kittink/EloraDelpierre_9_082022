//
//  WeatherViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

// ICI PROTOCOL POUR COMMUNIQUER

protocol WeatherDelegate: AnyObject {
    
    func updateScreen(newMeteoTemperature: String,
                      newMeteoImage: UIImage,
                      newMeteoLabel: String)
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    
    let newWeatherModel = WeatherModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
// ici on appelle une fonction qui va lancer le call API
        
        Task {
//            await WeatherService.shared.weatherRequestAwait()
            self.weatherTableView.reloadData()
        }
    }
}

class MeteoCell: UITableViewCell {

    @IBOutlet weak var meteoImage: UIImageView!
    @IBOutlet weak var meteoTemperature: UILabel!
    @IBOutlet weak var meteoLabel: UILabel!
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        WeatherService.shared.weatherDataArray.count
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeteoCityCell",
                                                 for: indexPath) as! MeteoCell
        
//        let cityShared = WeatherService.shared.weatherDataArray[indexPath.row]
        
//        cell.meteoLabel.text = "\(cityShared.name)"
//        cell.meteoTemperature.text = "\(cityShared.main.temp) °C"
//        cell.meteoImage.image = UIImage(named: cityShared.weather[0].icon)
        
        
        return cell
    }
}

// MARK: - WeatherDelegate
extension WeatherViewController: WeatherDelegate {
    
    func updateScreen(newMeteoTemperature: String, newMeteoImage: UIImage, newMeteoLabel: String) {
        
    }
}
