//
//  MeteoService.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//

import Foundation

private let kApiKey = "6549c66045e304a584b58f52e94acf59"

class MeteoService {
    
    // MARK: - Variables
    func fetchData(forCity: String, dataFetched: @escaping (MeteoResponse?) -> Void) {
        let meteoUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(kApiKey)&units=metric&q=\(forCity)")!
        
        let task = URLSession.shared.dataTask(with: meteoUrl) { data, response, error in
            guard
                error == nil,
                let data = data
            else {
                print(error ?? "Unknown error")
                dataFetched(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let response = try? jsonDecoder.decode(MeteoResponse.self, from: data)
            dataFetched(response)
        }
        
        task.resume()
    }
}

// call API les génériques
