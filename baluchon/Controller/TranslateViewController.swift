//
//  TranslateViewController.swift
//  baluchon
//
//  Created by Elora on 22/08/2022.
//

import UIKit

class TranslateViewController: UIViewController {
    
    // MARK: - Variables
    
    private var translateService: TranslateService!
    private let networkService = NetworkService()
    private var fromLangage: String = "fr"
    private var toLangage: String = "en"
    private var frenchToEnglish: Bool = true
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.hidesWhenStopped = true
        self.translateService = TranslateService(delegate: self)
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Valider",
                                         style: .done,
                                         target: self,
                                         action: #selector(self.closeKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        UpTextView.inputAccessoryView = toolBar
    }
    
    @objc
    func closeKeyboard() {
        UpTextView.resignFirstResponder()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var UpLabel: UILabel!
    @IBOutlet weak var DownLabel: UILabel!
    @IBOutlet weak var UpTextView: UITextView!
    @IBOutlet weak var DownTextView: UITextView!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var reverseBtn: UIButton!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    @IBAction private func reverseLangage() {
        self.frenchToEnglish.toggle()
        if frenchToEnglish {
            UpLabel.text = "Français"
            DownLabel.text = "Anglais"
            fromLangage = "fr"
            toLangage = "en"
        } else {
            UpLabel.text = "Anglais"
            DownLabel.text = "Français"
            
            fromLangage = "en"
            toLangage = "fr"
        }
    }
    
    @IBAction private func launchTranslation() {
        spiner.startAnimating()
        self.translateBtn.isEnabled = false
        
        self.translateService.gettranslation(for: UpTextView.text,
                                             from: self.fromLangage,
                                             to: self.toLangage, networkService: networkService)
    }
}

extension TranslateViewController: TranslateServiceDelegate {
    func didFinish(result: String) {
        DispatchQueue.main.async {
            self.DownTextView.text = result
            self.spiner.stopAnimating()
            self.translateBtn.isEnabled = true
        }
    }
    
    func didFail(error: Error) {
        print("🥹 Error: \(error.localizedDescription)")
    }
}
