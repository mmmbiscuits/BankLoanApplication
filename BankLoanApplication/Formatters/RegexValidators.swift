//
//  Validators.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

/// Validation of Email validity
/// - Parameter email: the email to be tested
/// - Returns: validity of email
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

func isValidIRDNumber(_ irdNumber: String) -> Bool {
    let irdNumberRegEx = "[0-9]{3}+-[0-9]{3}+-[0-9]{3}"
    
    let irdNumberPredicate = NSPredicate(format:"SELF MATCHES %@", irdNumberRegEx)
    return irdNumberPredicate.evaluate(with: irdNumber)
}

