//
//  Validators.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit


func validateEmail(_ email: String?) throws -> Void {
    
    guard let email else {
        throw ValidationError(message: "Email cannot be empty")
    }
    if email.isEmpty {
        throw ValidationError(message: "Email cannot be empty")
    }
    if !isValidEmail(email) {
        throw ValidationError(message: "Email is not valid")
    }
}

/// Validation of Email validity
/// - Parameter email: the email to be tested
/// - Returns: validity of email
///
///
func isValidEmail(_ email: String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: email)
}

func validateFullName(_ fullName: String?) throws -> Void {
    guard let fullName else {
        throw ValidationError(message: "Full Name cannot be empty")
    }
    if fullName.isEmpty {
        throw ValidationError(message: "Full Name cannot be empty")
    }
}

func validateGender(_ gender: String?) throws -> Void {
    guard let gender else {
        throw ValidationError(message: "A Gender must be selected")
    }
    if gender.isEmpty {
        throw ValidationError(message: "A Gender must be selected")
    }
}

func validateIRDNumber(_ irdNumber: String?) throws -> Void {
    guard let irdNumber else {
        throw ValidationError(message: "IRD Number cannot be empty")
    }
    if irdNumber.isEmpty {
        throw ValidationError(message: "IRD Number cannot be empty")
    }
    if !isValidIRDNumber(irdNumber) {
        throw ValidationError(message: "IRD Number is not valid")
    }
}

func isValidIRDNumber(_ irdNumber: String) -> Bool {
    let irdNumberRegEx = "[0-9]{3}+-[0-9]{3}+-[0-9]{3}|[0-9]{9}"
    let irdNumberPredicate = NSPredicate(format:"SELF MATCHES %@", irdNumberRegEx)
    return irdNumberPredicate.evaluate(with: irdNumber)
}

func validatePhoneNumber(_ phoneNumber: String?) throws -> Void {
    guard let phoneNumber else {
        throw ValidationError(message: "Phone Number cannot be empty")
    }
    if phoneNumber.isEmpty {
        throw ValidationError(message: "Phone Number cannot be empty")
    }
    if !isValidPhoneNumber(phoneNumber) {
        throw ValidationError(message: "Phone Number is not valid")
    }
}

func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneNumberRegEx = "[+\\s0-9]{2,12}"
    let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegEx)
    return phoneNumberPredicate.evaluate(with: phoneNumber)
}
