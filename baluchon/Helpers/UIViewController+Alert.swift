//
//  UIViewController+Alert.swift
//  baluchon
//
//  Created by Elora on 23/11/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(error: Error) {
        
        var errorMessage = error.localizedDescription
        let alert = UIAlertController(title: "Erreur", message: errorMessage,         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Action
            
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
