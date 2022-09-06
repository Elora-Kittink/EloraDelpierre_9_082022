//
//  TranslateViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

protocol TranslateDelegate: AnyObject {
    
    func updateScreen(result: String)
}

class TranslateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TranslationService.shared.getTranslation(for: "hello",
                                                 from: "en",
                                                 to: "fr") { results in
            print("😀")
            print(results)
        }
    }
}

//extension TranslateViewController: TranslateDelegate {
//
//    func updateScreen(result: String) {
//        <#code#>
//    }
//}
