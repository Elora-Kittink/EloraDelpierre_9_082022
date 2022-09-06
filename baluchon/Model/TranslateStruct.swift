//
//  TranslateStruct.swift
//  baluchon
//
//  Created by Elora on 05/09/2022.
//

import Foundation

struct TranslateResponse: Decodable {
    
    struct Translation: Decodable {
        
        let translatedText: String
    }
    
    struct Translations: Decodable {
        
        let translations: [Translation]
    }
    
    let data: Translations
}


//{
//  "data": {
//    "translations": [{
//      "translatedText": "La Gran Pirámide de Giza (también conocida como la Pirámide de Khufu o la Pirámide de Keops) es la más antigua y más grande de las tres pirámides en el complejo de la pirámide de Giza."
//    }]
//  }
//}
