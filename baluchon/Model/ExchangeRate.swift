//
//  Changes.swift
//  baluchon
//
//  Created by Elora on 10/08/2022.
//

import UIKit
import Foundation

class ExchangeRate {
    
    var exchangeRateData: [ExchangeRateStruct] = []

    let exchangeRateService = ExchangeRateService()
    
    func getExchangeRate(amount: Float, from: String, to: String) {
        DispatchQueue.main.async {
            self.exchangeRateService.fetchExchangeRate(amount: amount, from: from, to: to) { response in
                if let rateData = response {
                    print(rateData)
                    self.exchangeRateData.append(rateData)
                    print("TEST", self.exchangeRateData[0].result ?? 0)
                }
            }
        }
    }
    
}



