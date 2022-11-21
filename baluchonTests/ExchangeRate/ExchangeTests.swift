//
//  ExchangeTests.swift
//  baluchonTests
//
//  Created by Elora on 30/09/2022.
//
@testable import baluchon
import XCTest

//https://medium.com/@valsamiselmaliotis/mock-a-network-call-in-swift-6553ecdd3b81

class ExchangeTests: XCTestCase {



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
