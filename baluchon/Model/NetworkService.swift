//
//  NetworkService.swift
//  baluchon
//
//  Created by Elora on 13/10/2022.
//  "\(self.rootTranslate)?key=\(Constant.GoogleranslationApiKey)&format=\(translationFormat)&q=\(q!)&target=\(target!)&source=\(source!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!


//"?key=\(apiKey)&format=\(format)&q=\(q!)&target=\(target!)&source=\(source!)"

import Foundation

class NetworkService {
   static let shared = NetworkService()

    public func launchAPICall<T: Decodable>(url: String, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {

        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            var decodedResult: T?
            do {
                decodedResult = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
//                gestion d'erreur
                print("☠️\(error)")
            }
            guard let result = decodedResult else {
                print("☠️\(String(describing: error))")
                return
//                gestion d'erreur
            }
            completion(.success(result))
        })
        task.resume()
    }
}
