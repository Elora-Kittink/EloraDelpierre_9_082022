//
//  NetworkServiceMock.swift
//  baluchonTests
//
//  Created by Elora on 16/11/2022.
//

import Foundation

// MARK: - DataTask

protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSessionDataTask : URLSessionDataTaskProtocol {}

// doit se conformer au protocol URLSessionDataTaskProtocol
class MockURLSessionDataTask: URLSessionDataTaskProtocol {

    func resume() {}
}

// MARK: - URLSession

protocol URLSessionProtocol {
    
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {

    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol   {
       
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

// doit se conformer au protocol 
class MockURLSession: URLSessionProtocol {
    
    var dataTask = MockURLSessionDataTask()

    var completionHandler: (Data?, URLResponse?, Error?)

    init(completionHandler: (Data?, URLResponse? , Error?)) {
        self.completionHandler = completionHandler
    }
  
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
       
        completionHandler(self.completionHandler.0,
                          self.completionHandler.1,
                          self.completionHandler.2)
      
        return dataTask
    }
}
