//
//  ViewController.swift
//  baluchon
//
//  Created by Elora on 10/08/2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var euroLabel: UITextField!
    @IBOutlet weak var dollarLabel: UITextField!
    
    // MARK: - Variables
    private var exchangeRateService: ExchangeRateService!
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.exchangeRateService = ExchangeRateService(delegate: self)
    }

    // MARK: - Actions
    @IBAction private func didTapExchangeField(_ sender: UITextField) {
        let from: String
        let amount: Float
        let to: String

        if sender == self.euroLabel {
            from = "EUR"
            let senderText = sender.text
            amount = Float(senderText ?? "") ?? 0
            to = "USD"
        } else {
            from = "USD"
            let senderText = sender.text
            amount = Float(senderText ?? "") ?? 0
            to = "EUR"
        }

        self.exchangeRateService.fetchExchangeRate(amount: amount,
                                       from: from,
                                       to: to)
    }
    
}

// MARK: - ExchangeRateServiceDelegate
extension ExchangeViewController: ExchangeRateServiceDelegate {
    
    func didFinish(result: Float, from: String) {
        print("🥰 \(result)")
        
        DispatchQueue.main.async {
            if from.lowercased() == "eur" {
                self.dollarLabel.text = "\(result)"
            } else if from.lowercased() == "usd" {
                self.euroLabel.text = "\(result)"
            }
        }
    }
    
    func didFail(error: Error) {
        print("🥹 Error: \(error.localizedDescription)")
    }
}


