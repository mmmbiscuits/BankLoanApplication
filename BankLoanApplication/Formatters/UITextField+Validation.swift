//
//  UITextField+Validation.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 28/10/2024.
//

import UIKit
extension UITextField {
    
    func displayValidity(valid: Bool) {
        self.layer.borderWidth = 1
        self.layer.borderColor = (valid ? UIColor.clear : UIColor.red).cgColor
        self.layer.cornerRadius = 6
    }
    
}
