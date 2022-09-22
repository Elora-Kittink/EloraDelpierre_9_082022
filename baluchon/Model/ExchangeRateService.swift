//
//  ExchangeRateService.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import Foundation
import UIKit

enum GlobalError: LocalizedError {
    
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

    func fetchExchangeRate(amount: String?, from: String, to: String) {
        
        guard let amount = amount,
              let floatAmount = Float(amount)
        else {
            self.delegate.didFail(error: GlobalError.dataNotFound)
            return
        }
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Exchange_Rate_API_KEY") as? String else {
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return
        }
        
        guard let apiUrl = URL(string:"https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(floatAmount)&apikey=\(apiKey)")
        else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                self.delegate.didFail(error: error)
                return
            }
            
          guard let data = data else {
              self.delegate.didFail(error: GlobalError.dataNotFound)
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
//    func textFieldCheck(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if string == "," {
//            textField.text = textField.text! + "."
//            return false
//        }
//        return true
//}
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Restrict digits-only to specific UITextField(s)
//        if textField == creditCardNumberTextField {
//            let allowedCharacters = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//        }
//        return true
//    }
    
}

