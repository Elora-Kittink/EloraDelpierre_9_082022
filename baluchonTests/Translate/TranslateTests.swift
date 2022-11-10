//https://github.com/David-DaSilva7/LeBaluchon
//  TranslateTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//https://stackoverflow.com/questions/54569060/how-can-i-assert-a-delegate-is-called-in-my-unit-test

import XCTest
@testable import baluchon

class TransalteTest: XCTestCase {
    private func readLocalFile(forRessource: String) -> Data? {
            guard
//        bien penser à cocher la case "baluchonTests" dans la Target Membership et ne pas mettre Bundle.Main qui est le bundle de baluchon
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
    
    func testNoData() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, error: nil))
        translateService.getTranslation(for: "bonjour", from: "FR", to: "EN") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
            }
        }
    }
    
    func testErrorFromWS() {
        struct MyError: Error { }
        let translateService = TranslateService(session: URLSessionFake(data: nil, error: MyError()))
        translateService.getTranslation(for: "bonjour", from: "FR", to: "EN") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertTrue(error is MyError)
            }
        }
    }
    
    func testDecodingError() {
        struct MyError: Error { }
        let data = readLocalFile(forRessource: "TranslateFailJson")
        let translateService = TranslateService(session: URLSessionFake(data: data, error: nil))
        translateService.getTranslation(for: "Bonjour", from: "FR", to: "EN") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
        }
    }
    
    func testUrlError() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, error: nil))
        
        translateService.getTranslation(for: "bonjour", from: "  ", to: "EN") { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error as? GlobalError, GlobalError.urlApiNotCreated)
            }
        }
    }
}
