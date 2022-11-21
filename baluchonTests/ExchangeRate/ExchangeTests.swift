//
//  ExchangeTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//
@testable import baluchon
import XCTest

//https://medium.com/@valsamiselmaliotis/mock-a-network-call-in-swift-6553ecdd3b81

class ExchangeTests: XCTestCase, ExchangeRateServiceDelegate {
    var error: GlobalError?
    func didFinish(result: Float, from: String) { }
    
    func didFail(error: Error) {
        self.error = error as? GlobalError
    }
    
    func testUrlError() {
        let exchangeRateService = ExchangeRateService(delegate: self)

        let _ = exchangeRateService.fetchExangeRate(amount: "1", from: "USD", to: " ", networkService: NetworkService())
        
        XCTAssertEqual(self.error, GlobalError.urlApiNotCreated)
    }
    
    func testUrlAmoutNil() {
        let exchangeRateService = ExchangeRateService(delegate: self)

        let _ = exchangeRateService.fetchExangeRate(amount: nil, from: "USD", to: "EUR", networkService: NetworkService())
        
        XCTAssertEqual(self.error, GlobalError.incorrecInputEntries)
    }
    
    func testUrlSucces() {
        let exchangeRateService = ExchangeRateService(delegate: self)
        let urlTest = exchangeRateService.createUrl(amount: "45.8399", from: "USD", to: "EUR")
        XCTAssertEqual(urlTest, URL(string: "https://api.apilayer.com/fixer/convert?to=EUR&from=USD&amount=45.8399&apikey=Q7TgOKQMjvKgtASDohRF9LiMrOcG2thG"))
    }
}
