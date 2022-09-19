//
//  TranslateViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

protocol TranslateDelegate: AnyObject {
    
    func updateDownTextView(result: String)
    func updateUpLabel(result: String)
    func updateDownLabel(result: String)
}

class TranslateViewController: UIViewController {
    
    var translate = Translate()
    
    @IBOutlet weak var UpLabel: UILabel!
    @IBOutlet weak var DownLabel: UILabel!
    @IBOutlet weak var UpTextView: UITextView!
    @IBOutlet weak var DownTextView: UITextView!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var reverseBtn: UIButton!
    
    
    
    @IBAction private func reverseLangage() {
    
        self.translate.reverseLanguage()
    }
    
    @IBAction private func launchTranslation() {
        
        
        TranslationService.shared.getTranslation(for: UpTextView.text,
                                                 from: self.translate.fromLangage,
                                                 to: self.translate.toLangage) { results in
            DispatchQueue.main.async {
                self.updateDownTextView(result: results)
            }
    }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.translate.delegate = self
    }
    
}

extension TranslateViewController: TranslateDelegate {
    func updateDownTextView(result: String) {
        DownTextView.text = result
    }
    
    func updateUpLabel(result: String) {
        UpLabel.text = result
    }
    
    func updateDownLabel(result: String) {
        DownLabel.text = result
    }

}
