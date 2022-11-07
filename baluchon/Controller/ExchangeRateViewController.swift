//
//  ViewController.swift
//  baluchon
//
//  Created by Elora on 10/08/2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var downTextField: UITextField!
    @IBOutlet weak var upTextField: UITextField!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    // MARK: - Variables
    private var exchangeRateService: ExchangeRateService!
    private var fromCurrency: String = "USD"
    private var toCurrency: String = "EUR"
    private var usdToEur: Bool = true
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.hidesWhenStopped = true
        self.exchangeRateService = ExchangeRateService()
        
        self.upTextField.delegate = self
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Valider",
                                         style: .done,
                                         target: self,
                                         action: #selector(self.closeKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        upTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - Actions
    
    
    @IBAction private func launchExchangeRate() {
        spiner.startAnimating()
        launchButton.isEnabled = false
        //        self.exchangeRateService.fetchExchangeRate(amount: upTextField.text,
        //                                       from: fromCurrency,
        //                                                   to: toCurrency)
//        MARK: -   VIRER CETTE LOGIQUE DE LA VUE, utiliser le delegate?
    
        self.exchangeRateService.fetchExchangeRate(amount: upTextField.text, from: fromCurrency, to: toCurrency) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    print("🥹 Error")
                case .success(let changeRate):
                    self.downTextField.text = "\(changeRate)"
                    self.spiner.stopAnimating()
                    self.launchButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction private func toggleCurrency() {
        self.usdToEur.toggle()
        if usdToEur {
            fromCurrency = "usd"
            toCurrency = "eur"
            upLabel.text = "Dollar"
            downLabel.text = "Euro"
        } else {
            fromCurrency = "eur"
            toCurrency = "usd"
            upLabel.text = "Euro"
            downLabel.text = "Dollar"
        }
    }
    
    @objc
    func closeKeyboard() {
        upTextField.resignFirstResponder()
    }
    
}

// MARK: - ExchangeRateServiceDelegate
extension ExchangeViewController: ExchangeRateServiceDelegate {
    
    func didFinish(result: Float, from: String) {
        print("🥰 \(result)")
        
        DispatchQueue.main.async {
            self.downTextField.text = "\(result)"
            self.spiner.stopAnimating()
            self.launchButton.isEnabled = true
        }
        
    }
    
    func didFail(error: Error) {
        print("🥹 Error: \(error.localizedDescription)")
    }
}

// MARK: - UITextFieldDelegate
extension ExchangeViewController: UITextFieldDelegate {
    
    //    on veut remplacer la virgule par un point + on veut empêcher de commencer par une virgule +
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let containsDot = textField.text?.contains(".") ?? false
        
        if (range.location == 0 && string == ",") || (containsDot && string == ",") {
            return false
        }
        
        if string == "," {
            textField.text = (textField.text ?? "") + "."
            return false
        }
        
        return true
    }
}

