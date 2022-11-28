//
//  MeteoService.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//https://apilayer.com/marketplace/fixer-api#details-tab
//https://apilayer.com/marketplace/fixer-api

import Foundation

// MARK: - Protocol

protocol WeatherServiceDelegate: AnyObject {
    
    func didFinish(result: [WeatherStruct])
    func didFail(error: Error)
}

// MARK: - class

class WeatherService {
    
    private weak var delegate: WeatherServiceDelegate!
    
    init(delegate: WeatherServiceDelegate) {
        self.delegate = delegate
    }
    
    //    function taking all the cities and then pass them one by one for the fetch
    
    func fetchForCities(cities: [String], networkService: NetworkService) {
        var resultArray: [WeatherStruct?] = []
        
        cities.forEach { city in
            self.fetchOneCity(forCity: city, networkService: networkService) { result in
                switch result {
                case .success(let result):
                    resultArray.append(result)
                case .failure(let error):
                    self.delegate.didFail(error: error)
                }
                //                compactMap throw aways nil results
                if resultArray.count == cities.count {
                    let realResult = resultArray.compactMap { data in
                        return data
                }
                    self.delegate.didFinish(result: realResult)
                }
            }
        }
    }
    

    private func fetchOneCity(forCity: String, networkService: NetworkService, completion: @escaping (Result<WeatherStruct, Error>) -> Void) {
        
        guard let apiUrl = createUrl(forCity: forCity) else {
            return
        }
        let request = URLRequest(url: apiUrl)
        
        networkService.launchAPICall(urlRequest: request, expectingReturnType: WeatherStruct.self, completion: { result in
            switch result {
            case .success(let weather):
                completion(.success(weather))
            case .failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    
    func createUrl(forCity: String) -> URL? {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String else {
            
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return nil
        }
        //      in order to accept cities whith white space in name
        guard let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            
            self.delegate.didFail(error: GlobalError.incorrecInputEntries)
            return nil
        }
        
        guard  let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)") else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return nil
        }
        return apiUrl
    }
}
