//
//  WeatherTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//

import XCTest
@testable import baluchon


class WeatherTests: XCTestCase {

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
        print("print1")
        let weatherService =
        WeatherService(session: URLSessionFake(data: nil, error: nil))
        weatherService.fetchForCities(cities: ["Paris", "New York"]) { result in
            print("SUCCES  ☠️ \(result)")
            switch result {
            case .success:
                print("SUCCES  ☠️ \(result)")
            case .failure(let error):
                print("ERREUR  ☠️ \(error)")
                XCTAssertEqual(error as? GlobalError, GlobalError.dataNotFound)
            }
        }
    }
    
    func testErrorFromWS() {
        struct MyError: Error { }
        let weatherService = WeatherService(session: URLSessionFake(data: nil, error: MyError()))
        weatherService.fetchForCities(cities: ["Paris", "New York"]) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertTrue(error is MyError)
            }
        }
    }
    
    func testDecodingError() {
        let dataFailing = readLocalFile(forRessource: "WeatherFailJson")
        let weatherService = WeatherService(session: URLSessionFake(data: dataFailing, error: nil))
        weatherService.fetchForCities(cities: ["Paris", "New York"]) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("ERREUR \(error)")
                XCTAssertTrue(error is DecodingError)
            }
        }
    }
    
    func testUrlWhitInvalidCharacter() {
        let weatherService = WeatherService(session: URLSessionFake(data: nil, error: nil))
        weatherService.fetchForCities(cities: [" ", "☠️"]) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotEqual(error as? GlobalError, GlobalError.cityNotEncoding)
            }
        }
    }
}
