//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation
import UIKit

protocol ExchangeRateServiceDelegate: AnyObject {

    func didFinish(result: Float, from: String)
    func didFail(error: Error)
}

class ExchangeRateService {
    
   
    weak var delegate: ExchangeRateServiceDelegate!
    
    private var task: URLSessionDataTask?
    private var session: URLSession
    private var resourceUrl: URL?

    init(session: URLSession = URLSession(configuration: .default)) {
//        self.delegate = delegate
        self.session = session
//        let resourceString = "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)"
//        self.resourceUrl = URL(string: resourceString)
    }
//    init(session: URLSession = URLSession(configuration: .default)) {
//        self.session = session
//        let resourceString = "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)"
//        self.resourceUrl = URL(string: resourceString)
//    }

//    func fetchexangerate(amount: String?, from: String, to: String) {
//
//        guard let amount = amount,
//              let floatAmount = Float(amount)
//        else {
//            self.delegate.didFail(error: GlobalError.dataNotFound)
//            return
//        }
//
//        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String else {
//            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
//            return
//        }
//
//        guard let apiUrl = URL(string: "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)")
//        else {
//            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
//            return
//        }
//        let request = URLRequest(url: apiUrl)
//
//        NetworkService.shared.launchAPICall(url: request, expectingReturnType: ExchangeRateStruct.self, completion: { result in
//            switch result {
//            case .success(let rate):
////                ICI AUSSI RETURN RESULT COMME CA ON PEUT LE TESTER EN + DE L'ENVOYER AU DELEGATE?
//                self.delegate.didFinish(result: rate.result, from: from)
//            case .failure(let error):
//                self.delegate.didFail(error: error)
//            }
//        })
//    }
    
    
    func fetchExchangeRate(amount: String?, from: String, to: String, completion: @escaping (Result<Float, Error>)-> Void) {

        guard let amount = amount,
              let floatAmount = Float(amount)
        else {
//            self.delegate.didFail(error: GlobalError.dataNotFound)
            completion(.failure(GlobalError.invalidAmount))
            return
        }

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String else {
//            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            completion(.failure(GlobalError.apiKeyNotFound))
            return
        }

        guard let apiUrl = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)")
        else {
//            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            completion(.failure(GlobalError.urlApiNotCreated))
            return
        }

        task = session.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
//                self.delegate.didFail(error: error)
                completion(.failure(error))
                return
            }

          guard let data = data else {
//              self.delegate.didFail(error: GlobalError.dataNotFound)
              completion(.failure(GlobalError.dataNotFound))
              return
          }

            do {
                let responseJSON = try JSONDecoder().decode(ExchangeRateStruct.self,
                                                             from: data)
                completion(.success(responseJSON.result))
//                self.delegate.didFinish(result: responseJSON.result, from: from)
            } catch {
//                self.delegate.didFail(error: error)
                completion(.failure(error))
            }
      }
      task?.resume()
    }
}

