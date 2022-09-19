//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation

enum ExchangeRateError: LocalizedError {
    
    case apiKeyNotFound,
         urlApiNotCreated,
         dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "Api Key Not Found"
        case .urlApiNotCreated:
            return "URL Api Not Created"
        case .dataNotFound:
            return "Data Not Found"
        }
    }
}

protocol ExchangeRateServiceDelegate: AnyObject {
    
    func didFinish(result: Float, from: String)
    func didFail(error: Error)
}

class ExchangeRateService {
    
    weak var delegate: ExchangeRateServiceDelegate!
    
    init(delegate: ExchangeRateServiceDelegate) {
        self.delegate = delegate
    }

    func fetchExchangeRate(amount: Float, from: String, to: String) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String else {
            self.delegate.didFail(error: ExchangeRateError.apiKeyNotFound)
            return
        }
        
        guard let apiUrl = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)&apikey=\(apiKey)")
        else {
            self.delegate.didFail(error: ExchangeRateError.urlApiNotCreated)
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                self.delegate.didFail(error: error)
                return
            }
            
          guard let data = data else {
              self.delegate.didFail(error: ExchangeRateError.dataNotFound)
              return
          }
            
            do {
                let responseJSON = try JSONDecoder().decode(ExchangeRateStruct.self,
                                                             from: data)
                self.delegate.didFinish(result: responseJSON.result, from: from)
            } catch {
                self.delegate.didFail(error: error)
            }
      }
        
      task.resume()
    }
    
    //
    //    func fetchExchangeRate(amount: Float, from: String, to: String) async -> Float {
    //
    //        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String) ?? ""
    //
    //        let url2 = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)&apikey=\(apiKey)")!
    //
    //        do {
    //            let (data, response) = try await URLSession.shared.data(from: url2)
    //            let _data = try JSONDecoder().decode(ExchangeRateStruct.self, from: data)
    //            let exchangeRate = _data.result ?? 0
    //            return exchangeRate
    //        } catch {
    //            print(error)
    //            return 0
    //        }
    //    }
}

