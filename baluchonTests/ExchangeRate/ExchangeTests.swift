//
//  ExchangeTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//
@testable import baluchon
import XCTest

// on veut tester quoi?
// un url foireuse?
// un amour = nil?
// une apikey foireuse?
// un problème de décodage?
//

class ExchangeTests: XCTestCase {

    func testPasDeData() {
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil, error: nil))
        
        
        // When
        exchangeRateService.fetchExchangeRate(amount: "10",
                                              from: "EUR",
                                              to: "USD") { result in
            switch result {
            case .success:
                break
                
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
            }
        }
    }
    
    func testUneErreurDuWS() {
        
        struct MyError: Error { }
        
        // Given
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil, error: MyError()))
        
        
        // When
        exchangeRateService.fetchExchangeRate(amount: "10",
                                              from: "EUR",
                                              to: "USD") { result in
            switch result {
            case .success:
                break
                
            case .failure(let error):
                XCTAssertTrue(error is MyError)
            }
        }
    }
    
    func testAmountNil() {
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil, error: nil))
        
        exchangeRateService.fetchExchangeRate(amount: nil, from: "EUR", to: "USD") { result in
            switch result {
            case.success:
                break
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.invalidAmount)
            }
        }
    }
    
    func testDecodeFail() {
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: ExchangeRateOpertionalJson, error: nil))
    }
}
