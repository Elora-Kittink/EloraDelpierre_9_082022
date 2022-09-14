//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation



class ExchangeRateService {
    

    
    func fetchExchangeRate(amount: Float, from: String, to: String, dataFetched: @escaping (ExchangeRateStruct?) -> Void) {

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

          dataFetched(responseJSON)
      }
        
      task1.resume()
    
    }
}

