//
//  MeteoService.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//

import Foundation

enum WeatherError: LocalizedError {
    
    case cityNotEncoding
    
    var errorDescription: String? {
        switch self {
        case .cityNotEncoding:
            return "City not recongnized"
        }
    }
}

protocol WeatherServiceDelegate: AnyObject {
    
    func didFinish(result: [WeatherStruct])
}

class WeatherService {
    
    weak var delegate: WeatherServiceDelegate!
    
    init(delegate: WeatherServiceDelegate) {
        self.delegate = delegate
    }

    private func fetchOneCity(forCity: String, dataFetched: @escaping (WeatherStruct?, Error?) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String else {
            dataFetched(nil, GlobalError.apiKeyNotFound)
            return
        }
        
        guard let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            dataFetched(nil, WeatherError.cityNotEncoding)
            return
        }
        
        guard let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)")
        else {
            dataFetched(nil, GlobalError.urlApiNotCreated)
            return
        }

        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                dataFetched(nil, error)
                return
            }
            
          guard let data = data else {
              dataFetched(nil, GlobalError.dataNotFound)
              return
          }

            do {
                let responseJSON = try JSONDecoder().decode(WeatherStruct.self,
                                                            from: data)
                dataFetched(responseJSON, nil)
            } catch {
                dataFetched(nil, error)
            }
        }

        task.resume()
    }
    
    func fetchForCities(cities: [String]) {
        var result: [WeatherStruct?] = []
        
        cities.forEach { city in
            self.fetchOneCity(forCity: city) { response, error in
                if let error = error {
                    print("🥹 Error: \(error.localizedDescription)")
                }
                
                result.append(response)
                
                if result.count == cities.count {
                    let realResult = result.compactMap { data in
                        return data
                    }
                    
                    self.delegate.didFinish(result: realResult)
                }
            }
        }
    }
}
