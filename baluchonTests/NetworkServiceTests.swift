//
//  NetworkServiceTests.swift
//  baluchonTests
//
//  Created by Elora on 17/11/2022.
//
import XCTest
@testable import baluchon

final class NetworkServiceTests: XCTestCase {

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

        let data = readLocalFile(forRessource: file) // faut réussir à passer ça en nil
      
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return MockURLSession(completionHandler: (data, response, error))
    }
    func testNoData() {
//        je sais pas si ça merde a cause du data: nil ou du URL foireux
//        data = nil pas pareil de que data = ""
        let mockSession = createMockSession(fromJsonFile: "",
        andStatusCode: 200, andError: nil)
        let sut = NetworkService(session: mockSession!)
        sut.launchAPICall(url: URLRequest(url: URL(string: "test")!), expectingReturnType: TranslateStruct.self) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("👹 ERREUR DU TEST \(error)")
                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
            }
        }



//
//        let networkServiceMock = NetworkService(session: URLSessionFake(data: nil, error: nil))
//        let translateService = TranslateService(delegate: delegate)
//        translateService.gettranslation(for: "bonjour", from: "FR", to: "EN", networkService: networkServiceMock) { result in
//            switch result {
//            case .success:
//                break
//            case .failure(let error):
//                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
//            }
//        }
    }

}
