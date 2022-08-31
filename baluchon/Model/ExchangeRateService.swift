//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation



class ExchangeRateService {
    
   let exchangeRateUrl = URL(string: "https://api.apilayer.com/fixer/latest?apikey=kawx5n74IV33DFXX51kk4Rud6Tcj6aop")!
    
    
    func fetchExchangeRate(amount: Float, from: String, to: String, dataFetched: @escaping (ExchangeRateStruct?) -> Void) {

        let url2 = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)&apikey=kawx5n74IV33DFXX51kk4Rud6Tcj6aop")!
        
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
        
//        ----------------------------------------------
        
//        let task2 = URLSession.shared.dataTask(with: exchangeRateUrl) { data, response, error in
//            guard
//                error == nil,
//                let data = data
//            else {
//                print(error ?? "Unknown error")
//                dataFetched(nil)
//                return
//            }
//
//            let jsonDecoder = JSONDecoder()
//            let response = try? jsonDecoder.decode(ExchangeRateStruct.self, from: data)
//            dataFetched(response)
//        }
//
//        task2.resume()
    }
}

