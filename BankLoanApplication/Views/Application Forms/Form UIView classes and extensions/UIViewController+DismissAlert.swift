//
//  Alert.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 29/10/2024.
//

import UIKit

extension UIViewController {
    func presentDismissAlert() {
        let alert = UIAlertController(title: "Discard Application", message: "Are you sure you want to stop filling out your application?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            self.performSegue(withIdentifier: SegueIdentifiers.unwindAndSaveSegueIdentifier.rawValue, sender: nil)
        }
        let confirmAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

