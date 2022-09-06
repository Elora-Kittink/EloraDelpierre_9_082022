//
//  TranslateService.swift
//  baluchon
//
//  Created by Elora on 31/08/2022.
//

import Foundation

//TUTO   https://www.appcoda.com/google-translation-api/

//Méthode HTTP et URL :
//
//POST https://translation.googleapis.com/language/translate/v2
// DOC https://cloud.google.com/translate/docs/basic/translate-text-basic?hl=fr#translate_translate_text-drest

class TranslationService {
    
    static let shared = TranslationService()
    
    private let apiKey = "AIzaSyBvSyMDb8OQO5su-AImC2WzclGPsyNKKYI"
    
    private let apiUrl = "https://translation.googleapis.com/language/translate/v2"
    
    func getTranslation(for queryText: String,
                        from source: String,
                        to target: String,
                        dataFetched: @escaping (_ results: String?) -> Void) {
        let urlParams: [String: String] = [
            "q": queryText,
            "source": source,
            "target": target,
            "format": "text"
        ]
        
        let url = URL(string: self.apiUrl + "?key=" + self.apiKey)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(urlParams)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  error == nil
            else {
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200
            else {
                return
            }
            
            let responseJSON = try? JSONDecoder().decode(TranslateResponse.self, from: data)
            dataFetched(responseJSON?.data.translations.first?.translatedText)
        }
        
        task.resume()
    }
}
