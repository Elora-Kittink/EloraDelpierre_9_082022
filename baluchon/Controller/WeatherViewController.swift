//
//  WeatherViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

// ICI PROTOCOL POUR COMMUNIQUER

protocol WeatherDelegate: AnyObject {
    func updateScreen(newMeteoTemperature: String, newMeteoImage: UIImage, newMeteoLabel: String)
}

class WeatherViewController: UIViewController {

    let newWeatherModel = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// ici on appelle une fonction qui va lancer le call API 
//        newWeatherModel.modifierLabel()
    }
    

}

class MeteoCell: UITableViewCell {

    @IBOutlet weak var meteoImage: UIImageView!
    @IBOutlet weak var meteoTemperature: UILabel!
    @IBOutlet weak var meteoLabel: UILabel!
}

extension WeatherViewController: WeatherDelegate {
    
    func updateScreen(newMeteoTemperature: String, newMeteoImage: UIImage, newMeteoLabel: String) {
        
    }
}
