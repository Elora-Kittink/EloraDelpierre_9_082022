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
    
    func didFinish() { }
    
    func didFail(error: Error) {
        self.error = error as? GlobalError
    }
    
    private func readLocalFile(forRessource: String) -> Data? {
            guard
//        bien penser à cocher la case "baluchonTests" dans la Target Membership et ne pas mettre Bundle.Main qui est le bundle de baluchon
                let bundle = Bundle(identifier: "ExomindOpenclassrooms.baluchonTests"),
                let bundlePath = bundle
                .path(forResource: forRessource,
                      ofType: "json"),
                let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8)
            else {
                print("🤡")
                return nil
            }
            return jsonData
    }
    
    private func createMockSession(fromJsonFile file: String,
                            andStatusCode code: Int,
                            andError error: Error?) -> MockURLSession? {

        let data = readLocalFile(forRessource: file)
      
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return MockURLSession(completionHandler: (data, response, error))
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
    
    func testExchangeSucces() {
        let exchangeRateService = ExchangeRateService(delegate: self)
        let mockSession = createMockSession(fromJsonFile: "ExchangeRateSuccesJson",
                        andStatusCode: 200, andError: nil)
        let sut = NetworkService(session: mockSession!)
        exchangeRateService.fetchExangeRate(amount: "5", from: "USD", to: "EUR", networkService: sut)
        
        XCTAssertEqual(exchangeRateService.rateResult.count, 1)
    }
}
