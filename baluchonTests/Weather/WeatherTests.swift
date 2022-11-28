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
    func didFinish(result: [WeatherStruct]) {
        print("🤡 \(result)")
        resultArray.append(result[0])
    }
    
    func didFail(error: Error) {
        print("🤡 \(error)")
    }
    
    func testUrlSucces() {
        let weatherService = WeatherService(delegate: self)
       let url = weatherService.createUrl(forCity: "Paris")
        XCTAssertEqual(url, URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=6549c66045e304a584b58f52e94acf59&units=metric&q=Paris"))
    }
}
