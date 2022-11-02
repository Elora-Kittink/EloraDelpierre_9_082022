//
//  NetworkService.swift
//  baluchon
//
//  Created by Elora on 13/10/2022.

import Foundation

class NetworkService {
   static let shared = NetworkService()

    public func launchAPICall<T: Decodable>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            var decodedResult: T?
            do {
                decodedResult = try JSONDecoder().decode(T.self, from: data)
            }
            catch {
                print("decoding error : ☠️\(error)")
            }
            guard let result = decodedResult else {
                print("result error : ☠️\(String(describing: error))")
                return
            }
            completion(.success(result))
        })
        task.resume()
    }
}
