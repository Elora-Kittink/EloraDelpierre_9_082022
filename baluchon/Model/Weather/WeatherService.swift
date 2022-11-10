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
    
//    private weak var delegate: WeatherServiceDelegate!
//    private var service: NetworkService!
    private var task: URLSessionDataTask?
    private var session: URLSession
    private var resourceUrl: URL?
    
    init(session: URLSession = URLSession(configuration: .default)) {
//        self.delegate = delegate
        self.session = session
    }
    
//    function taking all the cities and then pass them one by one for the fetch
    
    func fetchForCities(cities: [String], completion: @escaping (Result<[WeatherStruct], Error>) -> Void) {
        var resultArray: [WeatherStruct?] = []
        
        cities.forEach { city in
            self.fetchOneCity(forCity: city) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let result):
                    resultArray.append(result)
                }
//                compactMap throw aways nil results
                if resultArray.count == cities.count {
                    let realResult = resultArray.compactMap { data in
                        return data
                    }
                    completion(.success(realResult))
//                    self.delegate.didFinish(result: realResult)
                }
            }
        }
    }
    
    
//    private func fetchonecity(forCity: String, dataFetched: @escaping (WeatherStruct?, Error?) -> Void) {
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String else {
//            dataFetched(nil, GlobalError.apiKeyNotFound)
//            return
//        }
////      in order to accept cities whith white space in name
//        guard let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        else {
//            dataFetched(nil, WeatherError.cityNotEncoding)
//            return
//        }
//
//        guard  let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)") else {
//            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
//            return
//        }
//        let request = URLRequest(url: apiUrl)
//
//        self.service.launchAPICall(url: request, expectingReturnType: WeatherStruct.self, completion: { result in
//            switch result {
//            case .success(let weather):
////                ICI AUSSI RETURN RESULT COMME CA ON PEUT LE TESTER EN + DE L'ENVOYER AU DELEGATE?
//                dataFetched(weather, nil)
//            case .failure(let error):
//                dataFetched(nil, error)
//            }
//
//        })
//    }

//    fetch data accepting one citie
    private func fetchOneCity(forCity: String, completion: @escaping (Result<WeatherStruct, Error>) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String else {
            completion(.failure(GlobalError.apiKeyNotFound))
            return
        }
//      in order to accept cities whith white space in name
        guard let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            completion(.failure(GlobalError.cityNotEncoding))
            return
        }

        guard let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)")
        else {
            completion(.failure(GlobalError.urlApiNotCreated))
            return
        }

        let task = session.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

          guard let data = data else {
              completion(.failure(GlobalError.dataNotFound))
              return
          }
            do {
                let responseJSON = try JSONDecoder().decode(WeatherStruct.self,
                                                            from: data)
                completion(.success(responseJSON))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
