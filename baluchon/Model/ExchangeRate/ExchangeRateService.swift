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

    init(delegate: ExchangeRateServiceDelegate) {
        self.delegate = delegate
    }

    func fetchExangeRate(amount: String?, from: String, to: String, networkService: NetworkService) {

        let apiUrl = createUrl(amount: amount, from: from, to: to)
        let request = URLRequest(url: apiUrl)

        networkService.launchAPICall(urlRequest: request, expectingReturnType: ExchangeRateStruct.self, completion: { result in
            switch result {
            case .success(let rate):
                self.delegate.didFinish(result: rate.result, from: from)
            case .failure(let error):
                self.delegate.didFail(error: error)
            }
        })
    }
    
    func createUrl(amount: String?, from: String, to: String) -> URL {
        
        guard let amount = amount,
              let floatAmount = Float(amount)
        else {
            self.delegate.didFail(error: GlobalError.dataNotFound)
            return URL(string: "fail")!
        }

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String else {
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return URL(string: "fail")!
        }

        guard let apiUrl = URL(string: "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)")
        else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return URL(string: "fail")!
        }
        return apiUrl
    }
}

