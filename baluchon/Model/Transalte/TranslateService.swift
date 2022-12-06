//
//  TranslateService.swift
//  baluchon
//
//  Created by Elora on 31/08/2022.
//

import Foundation

// MARK: - Protocol

protocol TranslateServiceDelegate: AnyObject {
    func didFinish()
    func didFail(error: Error)
}

// MARK: CLASS

class TranslateService {
    
    weak var delegate: TranslateServiceDelegate!
    var translatedQuote: [String] = []
    
    init(delegate: TranslateServiceDelegate) {
        self.delegate = delegate
    }
    

    func gettranslation(for queryText: String,
                        from source: String,
                        to target: String, format: String = "text", networkService: NetworkService) {
        
// empty result array from last translation
        translatedQuote = []
        guard let apiUrl = createApiUrl(queryText: queryText, source: source, target: target) else {
            return
        }
        let request = URLRequest(url: apiUrl)
        
// weak self pour eviter les fuites memoire
        networkService.launchAPICall(urlRequest: request, expectingReturnType: TranslateStruct.self, completion: { [weak self] result in
            switch result {
            case .success(let translatedText):
                self?.translatedQuote.append(translatedText.data.translations[0].translatedText)
                self?.delegate.didFinish()
            case .failure(let error):
                self?.delegate.didFail(error: error)
            }
        })
    }

// return URL in order to test
    func createApiUrl(queryText: String,
                      source: String,
                       target: String) -> URL? {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "Translate_API_KEY") as? String
        else {
            self.delegate.didFail(error: GlobalError.apiKeyNotFound)
            return nil
        }
// allow any type of character
        guard let queryTextPercent = queryText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            self.delegate.didFail(error: GlobalError.incorrecInputEntries)
            return nil
        }
        
        guard let apiUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(apiKey)&format=text&q=\(queryTextPercent)&target=\(target)&source=\(source)") else {
            self.delegate.didFail(error: GlobalError.urlApiNotCreated)
            return nil
        }
        return apiUrl
    }
}
 
