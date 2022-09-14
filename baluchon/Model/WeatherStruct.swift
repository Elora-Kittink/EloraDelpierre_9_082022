//
//  MeteoStruct.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//

import Foundation


struct WeatherStruct: Decodable {
    
    struct Weather: Decodable {
        
        let icon: String
    }
    
    struct Main: Decodable {
        
        let temp: Double
    }
    let name: String
    let weather : [Weather]
    let main: Main
}
