//
//  NetworkServiceTests.swift
//  baluchonTests
//
//  Created by Elora on 17/11/2022.
//
import XCTest
@testable import baluchon

final class NetworkServiceTests: XCTestCase {
//  transforme mes fichiers de test json en type Data
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
    
    private func createMockSession(fromJsonFile file: String,
                            andStatusCode code: Int,
                            andError error: Error?) -> MockURLSession? {

        let data = readLocalFile(forRessource: file)
      
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return MockURLSession(completionHandler: (data, response, error))
    }
    
    func testNoData() {
        
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        let mockSession2 = MockURLSession(completionHandler: (nil, response, nil))
        let sut = NetworkService(session: mockSession2)
        sut.launchAPICall(urlRequest: URLRequest(url: URL(string: "test")!), expectingReturnType: TranslateStruct.self) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("👹 ERREUR DU TEST \(error)")
                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
            }
        }
    }
    
    func testDecodingError() {
        let mockSession = createMockSession(fromJsonFile: "TranslateFailJson",
                andStatusCode: 200, andError: nil)
        let sut = NetworkService(session: mockSession!)
        sut.launchAPICall(urlRequest: URLRequest(url: URL(string: "test")!), expectingReturnType: TranslateStruct.self) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
        }
    }
}
