//
//  NetworkService.swift
//  baluchon
//
//  Created by Elora on 13/10/2022.

import Foundation

class NetworkService {
    
// session conforme au protocol où DataTask renvoie un URLSessionDataTaskProtocol
    private var session: URLSessionProtocol

    
    // par default utilise le vrai URLSession mais peut etre modifié en injectant le mock en init
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func launchAPICall<T: Decodable>(urlRequest: URLRequest, expectingReturnType: T.Type, completion: @escaping ((Result<T, Error>) -> Void)) {

        let task = session.dataTask(with: urlRequest, completionHandler: { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(GlobalError.dataNotFound))
                return
            }
            do {
                let decodedResult = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResult))
            } catch {
                completion(.failure(error))
                print("decoding error : ☠️\(error)")
            }
        })
        task.resume()
    }
}
