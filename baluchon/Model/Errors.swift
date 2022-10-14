//
//  Errors.swift
//  baluchon
//
//  Created by Elora on 14/10/2022.
//

import Foundation

enum GlobalError: LocalizedError {
    
    case apiKeyNotFound,
         urlApiNotCreated,
         dataNotFound
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "Api Key Not Found"
        case .urlApiNotCreated:
            return "URL Api Not Created"
        case .dataNotFound:
            return "Data Not Found"
        }
    }
}
