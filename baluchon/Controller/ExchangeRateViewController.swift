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
    private let networkService = NetworkService()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Taux de change"
        toggleButton.layer.cornerRadius = 5
        launchButton.layer.cornerRadius = 5
        launchButton.layer.borderColor = UIColor(named: "number2")?.cgColor
        launchButton.layer.borderWidth = 2
        downTextField.layer.borderColor = UIColor(named: "number4")?.cgColor
        downTextField.layer.borderWidth = 2
        downTextField.layer.cornerRadius = 5
        upTextField.layer.borderWidth = 2
        upTextField.layer.borderColor = UIColor(named: "number4")?.cgColor
        upTextField.layer.cornerRadius = 5
        toggleButton.layer.borderWidth = 2
        toggleButton.layer.borderColor = UIColor(named: "number2")?.cgColor
        spiner.hidesWhenStopped = true
        self.exchangeRateService = ExchangeRateService(delegate: self)
        
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
    
    func refresh() {
        DispatchQueue.main.async {
            self.downTextField.text = "\(self.exchangeRateService.rate)"
            self.spiner.stopAnimating()
            self.launchButton.isEnabled = true
        }
    }
    
    
    @IBAction private func launchExchangeRate() {
        spiner.startAnimating()
        launchButton.isEnabled = false
        
        self.exchangeRateService.fetchExangeRate(amount: upTextField.text, from: fromCurrency, to: toCurrency, networkService: networkService)
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
        self.refresh()
//        DispatchQueue.main.async {
//            self.downTextField.text = "\(result)"
//            self.spiner.stopAnimating()
//            self.launchButton.isEnabled = true
//        }
        
    }
    
    func didFail(error: Error) {
        print("🥹 Error: \(error.localizedDescription)")
        self.showAlert(error: error)
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

