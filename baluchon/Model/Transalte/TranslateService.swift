//
//  TranslateService.swift
//  baluchon
//
//  Created by Elora on 31/08/2022.
//

import Foundation

protocol TranslateServiceDelegate: AnyObject {
    func didFinish(result: String)
    func didFail(error: Error)
}

class TranslateService {
    
    weak var delegate: TranslateServiceDelegate!
    
    init(delegate: TranslateServiceDelegate) {
        self.delegate = delegate
    }
    
    
    func gettranslation(for queryText: String,
                        from source: String,
                        to target: String, format: String = "text") {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Translate_API_KEY") as? String
        else {
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return
        }
        
        let queryText = queryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let apiUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)&format=\(format)&q=\(queryText)&target=\(target)&source=\(source)") else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return
        }
        let request = URLRequest(url: apiUrl )
        
        NetworkService.shared.launchAPICall(url: request, expectingReturnType: TranslateStruct.self, completion: { result in
            switch result {
            case .success(let translatedText):
//                ICI AUSSI RETURN RESULT COMME CA ON PEUT LE TESTER EN + DE L'ENVOYER AU DELEGATE?
                self.delegate.didFinish(result: translatedText.data.translations[0].translatedText)
            case .failure(let error):
                self.delegate.didFail(error: error)
            }
            
        })
    }


    func getTranslation(for queryText: String,
                        from source: String,
                        to target: String, format: String = "text") {

        let urlParams: [String: String] = [
            "q": queryText,
            "source": source,
            "target": target,
            "format": "text"
        ]

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Translate_API_KEY") as? String
        else {
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return
        }

//        guard let ApiUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)")
        guard let ApiUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)&format=\(format)&q=\(queryText)&target=\(target)&source=\(source)")

        else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return
        }

        var request = URLRequest(url: ApiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(urlParams)
        } catch {
            self.delegate.didFail(error: error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.delegate.didFail(error: error)
                return
            }
            guard let data = data else {
                self.delegate.didFail(error: GlobalError.dataNotFound)
                return
            }

            do {
                let responseJSON = try JSONDecoder().decode(TranslateStruct.self, from: data)
                self.delegate.didFinish(result: responseJSON.data.translations[0].translatedText)
            }
            catch {
                self.delegate.didFail(error: error)
            }
        }
        task.resume()
    }
}
