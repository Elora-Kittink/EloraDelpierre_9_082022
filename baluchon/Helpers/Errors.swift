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
         dataNotFound,
         invalidAmount,
         invalidRequest,
         incorrecInputEntries
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "Api Key Not Found"
        case .urlApiNotCreated:
            return "URL Api Not Created"
        case .dataNotFound:
            return "Data Not Found"
        case .invalidAmount:
            return "Montant invalide"
        case .invalidRequest:
            return "Requete invalide"
        case .incorrecInputEntries:
            return "Saisie invalide"
        }
    }
}
