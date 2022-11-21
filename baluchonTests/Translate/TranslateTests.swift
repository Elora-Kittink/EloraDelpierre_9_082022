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
    
    func didFinish(result: String) { }
    
    func didFail(error: Error) { self.error = error as? GlobalError }
    
    
    func testUrlError() {
        let translateService = TranslateService(delegate: self)

        let _ = translateService.gettranslation(for: "bonjour", from: "EN", to: " ", networkService: NetworkService())
        
        XCTAssertEqual(self.error, GlobalError.urlApiNotCreated)
        
    }
    func testUrl() {
        let translateService = TranslateService(delegate: self)
        let urlTest = translateService.createApiUrl(queryText: "Test unitaire numéro 2", source: "fr", target: "en")
        XCTAssertEqual(urlTest, URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyBvSyMDb8OQO5su-AImC2WzclGPsyNKKYI&format=text&q=Test%20unitaire%20num%C3%A9ro%202&target=en&source=fr"))
    }
}

