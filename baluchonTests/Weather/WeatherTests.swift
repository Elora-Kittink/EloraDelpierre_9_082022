//
//  WeatherTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//

import XCTest
@testable import baluchon


class WeatherTests: XCTestCase, WeatherServiceDelegate {
    
    var error: GlobalError?
    var resultArray: [WeatherStruct] = []
    func didFinish() {
        
    }
    
    func didFail(error: Error) {
        print("🤡 \(error)")
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
    
    func testUrlSucces() {
       let weatherService = WeatherService(delegate: self)
       let url = weatherService.createUrl(forCity: "Paris")
        XCTAssertEqual(url, URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=6549c66045e304a584b58f52e94acf59&units=metric&q=Paris"))
    }
    
    func testWeatherSucces() {
        let weatherService = WeatherService(delegate: self)
        let mockSession = createMockSession(fromJsonFile: "WeatherSuccesJson",
                        andStatusCode: 200, andError: nil)
        let sut = NetworkService(session: mockSession!)

        weatherService.fetchForCities(cities: ["Paris", "Marseille"], networkService: sut)
        
        XCTAssertEqual(weatherService.weather.count, 2)
    }
}
