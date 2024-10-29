//
//  ValidationError.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 29/10/2024.
//


struct ValidationError: Error {
    let message: String
    init(message: String) {
        self.message = message
    }
}