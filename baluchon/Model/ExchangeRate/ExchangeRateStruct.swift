//
//  ExchangeRateStruct.swift
//  baluchon
//
//  Created by Elora on 25/08/2022.
//

import Foundation

struct ExchangeRateStruct: Decodable {
    struct Query: Decodable {
        let from: String
        let to: String
        let amount: Double
    }
    struct Info: Decodable {
        let timestamp: Int
        let rate: Float
    }
    let info: Info?
    let query: Query?
    let success: Bool
    let date: String
    let result: Float
}
