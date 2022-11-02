//
//  MeteoService.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//https://apilayer.com/marketplace/fixer-api#details-tab
//https://apilayer.com/marketplace/fixer-api

import Foundation

// specific weather error
enum WeatherError: LocalizedError {
    
    case cityNotEncoding
    
    var errorDescription: String? {
        switch self {
        case .cityNotEncoding:
            return "City not recongnized"
        }
    }
}

// MARK: - Protocol

protocol WeatherServiceDelegate: AnyObject {
    
    func didFinish(result: [WeatherStruct])
    func didFail(error: Error)
}

// MARK: - class

class WeatherService {
    
    weak var delegate: WeatherServiceDelegate!
    
    init(delegate: WeatherServiceDelegate) {
        self.delegate = delegate
    }
    
//    function taking all the cities and then pass them one by one for the fetch
    
    func fetchForCities(cities: [String]) {
        var result: [WeatherStruct?] = []
        
        cities.forEach { city in
            self.fetchonecity(forCity: city) { response, error in
                if let error = error {
                    print("🥹 Error: \(error.localizedDescription)")
                }
                
                result.append(response)
                
//                compactMap throw aways nil results
                if result.count == cities.count {
                    let realResult = result.compactMap { data in
                        return data
                    }
                    self.delegate.didFinish(result: realResult)
                }
            }
        }
    }
    
    
    private func fetchonecity(forCity: String, dataFetched: @escaping (WeatherStruct?, Error?) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String else {
            dataFetched(nil, GlobalError.apiKeyNotFound)
            return
        }
//      in order to accept cities whith white space in name
        guard let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else {
            dataFetched(nil, WeatherError.cityNotEncoding)
            return
        }
        
        guard  let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)") else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return
        }
        let request = URLRequest(url: apiUrl)
        
        NetworkService.shared.launchAPICall(url: request, expectingReturnType: WeatherStruct.self, completion: { result in
            switch result {
            case .success(let weather):
//                ICI AUSSI RETURN RESULT COMME CA ON PEUT LE TESTER EN + DE L'ENVOYER AU DELEGATE?
                dataFetched(weather, nil)
            case .failure(let error):
                dataFetched(nil, error)
            }
            
        })
    }
    
    
    
    
    
    
    
    
    
//
////    fetch data accepting one citie
//    private func fetchOneCity(forCity: String, dataFetched: @escaping (WeatherStruct?, Error?) -> Void) {
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
//        guard let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric&q=\(city)")
//        else {
//            dataFetched(nil, GlobalError.urlApiNotCreated)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
//            if let error = error {
//                dataFetched(nil, error)
//                return
//            }
//
//          guard let data = data else {
//              dataFetched(nil, GlobalError.dataNotFound)
//              return
//          }
//
//            do {
//                let responseJSON = try JSONDecoder().decode(WeatherStruct.self,
//                                                            from: data)
//                dataFetched(responseJSON, nil)
//            } catch {
//                dataFetched(nil, error)
//            }
//        }
//
//        task.resume()
//    }
}
