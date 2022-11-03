//
//  NetworkService.swift
//  baluchon
//
//  Created by Elora on 13/10/2022.

import Foundation

class NetworkService {
    
 static let shared = NetworkService()
//    plutot passer en parametres ressourceurl + session + task ??
    public func launchAPICall<T: Decodable>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            var decodedResult: T?
            do {
                decodedResult = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                print("decoding error : ☠️\(error)")
            }
            guard let result = decodedResult else {
                print("result error : ☠️\(String(describing: error))")
                return
            }
            completion(.success(result))
        })
        task.resume()
    }
}

//class MockWeatherSuccessNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
//
//class MockWeatherFailNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
//
//class MockExchanceRateSuccessNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
//
//class MockExchanceRateFailNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
//
//class MockTranslateSuccessNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
//
//class MockTranslateFailNetworkService: NetworkService {
//
//    override func launchAPICall<T>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
//        let result = WeatherStruct(name: "Ma ville de test",
//                                   weather: [WeatherStruct.Weather(icon: "01d")],
//                                   main: WeatherStruct.Main(temp: 35))
//
//        completion(.success(result))
//    }
//}
