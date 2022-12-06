//https://github.com/David-DaSilva7/LeBaluchon
//  TranslateTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//https://stackoverflow.com/questions/54569060/how-can-i-assert-a-delegate-is-called-in-my-unit-test

import XCTest
@testable import baluchon

final class TranslateServiceTests: XCTestCase, TranslateServiceDelegate {
    
    var error: GlobalError?
    
    func didFinish() { }
    
    func didFail(error: Error) { self.error = error as? GlobalError }
    
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
        let translateService = TranslateService(delegate: self)

        let _ = translateService.gettranslation(for: "bonjour", from: "EN", to: " ", networkService: NetworkService())
        
        XCTAssertEqual(self.error, GlobalError.urlApiNotCreated)
        
    }
    func testUrlSucces() {
        let translateService = TranslateService(delegate: self)
        let urlTest = translateService.createApiUrl(queryText: "Test unitaire numéro 2", source: "fr", target: "en")
        XCTAssertEqual(urlTest, URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyBvSyMDb8OQO5su-AImC2WzclGPsyNKKYI&format=text&q=Test%20unitaire%20num%C3%A9ro%202&target=en&source=fr"))
    }
    
    func testTranslateSuccess() {
        let translateService = TranslateService(delegate: self)
        let mockSession = createMockSession(fromJsonFile: "TranslateSuccesJson",
                        andStatusCode: 200, andError: nil)
        let sut = NetworkService(session: mockSession!)
        translateService.gettranslation(for: "test en cours", from: "FR", to: "EN", networkService: sut)
        XCTAssertEqual(translateService.translatedQuote.count, 1)
    }
}

