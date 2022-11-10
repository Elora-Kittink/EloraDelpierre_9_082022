//
//  NetworkService.swift
//  baluchon
//
//  Created by Elora on 13/10/2022.

import Foundation

class NetworkService {
    
    private var session: URLSession
    static let shared = NetworkService()

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    public func launchAPICall<T: Decodable>(url: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {

        let task = session.dataTask(with: url, completionHandler: { data, _, error in
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
