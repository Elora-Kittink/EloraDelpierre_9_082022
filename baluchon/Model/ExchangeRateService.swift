//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation



class ExchangeRateService {
    
    @available(iOS 15, *)
    func fetchExchangeRate(amount: Float, from: String, to: String) async -> Float {
        
        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String) ?? ""
        
        let url2 = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)&apikey=\(apiKey)")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url2)
            let _data = try JSONDecoder().decode(ExchangeRateStruct.self, from: data)
            let exchangeRate = _data.result ?? 0
            return exchangeRate
        } catch {
            print(error)
            return 0
        }
    }
    
    
    @available(iOS 11, *)
    func fetchExchangeRate(amount: Float, from: String, to: String, dataFetched: @escaping (Float) -> Void) {

        let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String
        
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
                        return
        }
        
        let url2 = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)&apikey=\(key)")!
        
      let session = URLSession(configuration: .default)
      let task1 = session.dataTask(with: url2) { data, response, error in
          guard let data = data, error == nil else {
              return
          }
          guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
              return
          }
          let responseJSON = try? JSONDecoder().decode(ExchangeRateStruct.self, from: data)
          let exchangeRate = responseJSON?.result
          dataFetched(exchangeRate ?? 0)
      }
        
      task1.resume()
    
    }
}

