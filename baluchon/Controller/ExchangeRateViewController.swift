//
//  ViewController.swift
//  baluchon
//
//  Created by Elora on 10/08/2022.
//

import UIKit

protocol ExchangeRateDelegate: AnyObject {
    func updateScreen(result: String)
}

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var euroLabel: UITextField! {
        didSet {
            self.euroLabel.delegate = self
        }
    }
    
    @IBOutlet weak var dollarLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

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

        ExchangeRate().getExchangeRate(amount: amount,
                                       from: from,
                                       to: to)
    }
    
}

extension ExchangeViewController: ExchangeRateDelegate, UITextFieldDelegate {
    
    func updateScreen(result: String) { }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let oldText = textField.text, let r = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: r, with: string)
//        guard let value = Double(newText.replacingOccurrences(of: ",", with: ".")) else { return false }
        return true
    }

}


