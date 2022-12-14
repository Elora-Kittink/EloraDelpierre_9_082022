//
//  URLSessionFake.swift
//  baluchonTests
//
//  Created by Elora on 02/11/2022.
//

import Foundation



class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, error: Error?, response: URLResponse? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(
            data: data,
            urlResponse: response,
            responseError: error,
            completionHandler: completionHandler
        )
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(
            data: data,
            urlResponse: response,
            responseError: error,
            completionHandler: completionHandler
        )
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
// https://medium.com/@valsamiselmaliotis/mock-a-network-call-in-swift-6553ecdd3b81
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.completionHandler = completionHandler
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
}
