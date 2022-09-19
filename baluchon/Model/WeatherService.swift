//
//  MeteoService.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//

import Foundation

//private let kApiKey = "6549c66045e304a584b58f52e94acf59"

class WeatherService {
    
    private var weatherApiKey: String
    
        var weatherDataArray: [WeatherStruct] = []
    
    // MARK: - Variables
    
    let citys = ["Paris", "New York"]
    
    // MARK: - Init
    private init() {
        self.weatherApiKey = (Bundle.main.object(forInfoDictionaryKey: "Weather_API_KEY") as? String) ?? ""
    }
    

//    func fetchDataAwait(forCity: String) async -> WeatherStruct? {
//        let city = forCity.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
//        let meteoUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(self.weatherApiKey)&units=metric&q=\(city)")!
//
//        do {
//            let (data, response) = try await URLSession.shared.data(from: meteoUrl)
//            let _data = try JSONDecoder().decode(WeatherStruct.self, from: data)
//            print(data)
//            return _data
//        } catch {
//            print(error)
//            return nil
//        }
//    }
    
    

//
//    func weatherRequestAwait() async {
//        await withTaskGroup(of: Void.self) { group in
//            
//            self.citys.forEach { city in
//                group.addTask {
//                    print(city)
//                    let response = await self.fetchDataAwait(forCity: city)
//                    
//                    if let weatherData = response {
//                        self.weatherDataArray.append(weatherData)
//                    }
//                }
//            }
//            await group.waitForAll()
//        }
//    }
    

    func fetchData(forCity: String, dataFetched: @escaping (WeatherStruct?) -> Void) {
        let meteoUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(String(describing: self.weatherApiKey))&units=metric&q=\(forCity)")!

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
            let response = try? jsonDecoder.decode(WeatherStruct.self, from: data)
            guard let weatherData = response else { return }

            self.weatherDataArray.append(weatherData)
            dataFetched(response)
        }

        task.resume()
    }
    
 
    func weatherRequest(completion: @escaping (() -> Void)) {

        DispatchQueue.main.async {
            self.citys.forEach { city in
                self.fetchData(forCity: city) { response in
                    if let meteoData = response {
                        self.weatherDataArray.append(meteoData)
                    }
                }
            }
            completion()
        }
    }
}
