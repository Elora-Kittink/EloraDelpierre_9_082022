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
//https://medium.com/@valsamiselmaliotis/mock-a-network-call-in-swift-6553ecdd3b81

class ExchangeTests: XCTestCase {
    
    private func readLocalFile(forRessource: String) -> Data? {
        guard
//     bien penser à cocher la case "baluchonTests" dans la Target Membership et ne pas mettre Bundle.Main qui est le bundle de baluchon
            let bundle = Bundle(identifier: "ExomindOpenclassrooms.baluchonTests"),
            let bundlePath = bundle
                .path(forResource: forRessource,
                      ofType: "json"),
            let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8)
        else {
            return nil
        }
        
        return jsonData
    }
    
    func testPasDeData() {
        
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil, error: nil))
        
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
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.invalidAmount)
            }
        }
    }
    
    func testDecodeFail() {
        //        https://programmingwithswift.com/parse-json-from-file-and-url-with-swift/
        let data = readLocalFile(forRessource: "ExchangeRateFailJson")
        
        struct MyError: Error { }
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(
            data: data,
            error: nil))
        
        exchangeRateService.fetchExchangeRate(amount:"12", from: "EUR", to: "USD") { result in
            switch result {
                
            case .success:
                break
                
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
        }
    }
    
    func testUrlPasBonne() {
        let exchangeRateService = ExchangeRateService(session: URLSessionFake(data: nil, error: nil))
        
        exchangeRateService.fetchExchangeRate(amount: "1", from: "  ", to: "USD") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.urlApiNotCreated)
            }
        }
    }
}
