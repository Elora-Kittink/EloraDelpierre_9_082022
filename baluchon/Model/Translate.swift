//
//  Translate.swift
//  baluchon
//
//  Created by Elora on 14/09/2022.
//

import Foundation

class Translate {
    
    weak var delegate: TranslateDelegate?
    
    var fromLangage: String = "fr"
    var toLangage: String = "en"
    var frenchToEnglish: Bool = true
    
    func reverseLanguage() {
    
        if frenchToEnglish {
            fromLangage = "en"
            toLangage = "fr"
            frenchToEnglish = false
            delegate?.updateUpLabel(result: "Anglais")
            delegate?.updateDownLabel(result: "Français")
        } else {
            fromLangage = "fr"
            toLangage = "en"
            frenchToEnglish = true
            delegate?.updateUpLabel(result: "Français")
            delegate?.updateDownLabel(result: "Anglais")
        }
    }
}
