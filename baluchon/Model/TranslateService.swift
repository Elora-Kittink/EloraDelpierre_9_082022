//
//  TranslateService.swift
//  baluchon
//
//  Created by Elora on 31/08/2022.
//

import Foundation

class TranslationService {
    
    static let shared = TranslationService()
    
    let apiKey = Bundle.main.object(forInfoDictionaryKey: "Translate_API_KEY") as? String
    
    private let apiUrl = "https://translation.googleapis.com/language/translate/v2"
    
    func getTranslation(for queryText: String, from source: String, to target: String) async -> TranslateStruct? {
        let translateUrl = URL(string: apiUrl)!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: translateUrl)
            let _data = try JSONDecoder().decode(TranslateStruct.self, from: data)
            print(data)
            return _data
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func getTranslation(for queryText: String,
                        from source: String,
                        to target: String,
                        dataFetched: @escaping (_ results: String) -> Void) {
        let urlParams: [String: String] = [
            "q": queryText,
            "source": source,
            "target": target,
            "format": "text"
        ]
        
        let url = URL(string: self.apiUrl + "?key=" + (self.apiKey ?? ""))!
        
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
            
            let responseJSON = try? JSONDecoder().decode(TranslateStruct.self, from: data)
            dataFetched(responseJSON?.data.translations.first?.translatedText ?? "FAIL")
        }
        
        task.resume()
    }
}
