//
//  LoanApplicationViewModel.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 30/10/2024.
//

import Foundation
import UIKit

enum TextfieldTag: Int {
    case fullName = 0, phoneNumber = 1, email = 2, gender = 3, address = 4, loanAmount = 5, annualIncome = 6, irdNumber = 7
}
struct TextfieldError {
    var textfieldTag: TextfieldTag
    let error: Error
}

class LoanApplicationViewModel {

    let loanApplication: DraftLoanApplication
    
    private let loanToIncomeRatio: Double = 0.5
    
    var fieldsWithErrors: [TextfieldError] = []
    
    init(loanApplication: DraftLoanApplication) {
        self.loanApplication = loanApplication
    }
    
    func areAllFieldsValid() -> Bool {
        
        do {
            try areUserFieldValid()
            try areLoanFieldValid()
        } catch {
            return false
        }
        return true
    }
    
    func areUserFieldValid() throws {
        
        try validateFullName(loanApplication.fullName)
        try validateEmail(loanApplication.email)
        try validateGender(loanApplication.gender)
    }
    
    func areLoanFieldValid() throws {
        try validateIRDNumber(loanApplication.irdNumber)
        try validateLoanRatio(income: loanApplication.annualIncome, loanAmount: loanApplication.loanAmount, loanToIncomeRatio: loanToIncomeRatio )
    }
    
    
    func irdNumberString() -> String {
        return loanApplication.irdNumber ?? ""
    }
    
    
    //MARK: - setting
    func setFullName(_ fullName: String, validate: Bool = false) {
        loanApplication.fullName = fullName
        testValidation(validate: validate, textfieldTag: .fullName)
    }
    func setEmail(_ email: String, validate: Bool = false) {
        loanApplication.email = email
        testValidation(validate: validate, textfieldTag: .fullName)
    }
    func setPhoneNumber(_ phoneNumber: String, validate: Bool = false) {
        loanApplication.phoneNumber = phoneNumber
        testValidation(validate: validate, textfieldTag: .phoneNumber)
    }
    func setGender(_ gender: String, validate: Bool = false) {
        loanApplication.gender = gender
        testValidation(validate: validate, textfieldTag: .gender)
    }
    func setAddress(_ address: String, validate: Bool = false) {
        loanApplication.address = address
        testValidation(validate: validate, textfieldTag: .address)
    }
    
    func setAnnualIncome(_ annualIncome: Double, validate: Bool = false) {
        loanApplication.annualIncome = annualIncome
        testValidation(validate: validate, textfieldTag: .annualIncome)
    }
    func setLoanAmount(_ loanAmount: Double, validate: Bool = false) {
        loanApplication.loanAmount = loanAmount
        testValidation(validate: validate, textfieldTag: .loanAmount)
    }
    
    func setIRDNumber(_ irdNumber: String, validate: Bool = false) {
        loanApplication.irdNumber = irdNumber
    }
    
    func testValidation(validate: Bool, textfieldTag: TextfieldTag) {
        guard validate else { return }
        
        do {
            switch textfieldTag {
                case .fullName:
                try validateFullName(loanApplication.fullName)
            case .email:
                try validateEmail(loanApplication.email)
            case .phoneNumber:
                try validatePhoneNumber(loanApplication.phoneNumber)
            case .gender:
                try validateGender(loanApplication.gender)
//            case .annualIncome:
//                try validateLoanRatio(income: <#T##Double?#>, loanAmount: <#T##Double?#>, loanToIncomeRatio: <#T##Double#>)(loanApplication.annualIncome)
//            case .loanAmount:
//                try validateLoanAmount(loanApplication.loanAmount)
            case .irdNumber:
                try validateIRDNumber(loanApplication.irdNumber)
            default:
                return
            }
        } catch {
            fieldsWithErrors.append(TextfieldError(textfieldTag: textfieldTag, error: error))
        }
 
    }
    
}
