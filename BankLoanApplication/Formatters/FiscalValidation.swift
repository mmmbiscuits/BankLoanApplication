//
//  Untitled.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//


/// Validation of loan to income.
/// - Parameters:
///   - income: income amount
///   - loanAmount: loan amount
///   - loanToIncomeRatio: the loan to income ratio presented as a multiplier. i.e 2.0 is a loan 2 time the income of the applicant.
/// - Returns: Bool if the loan to income is valid for the ratio.
///

func validateLoanRatio(income: String?, loanAmount: String?, loanToIncomeRatio: Double) throws -> Void {
    guard let income = income else {
        throw ValidationError(message: "income not set")
    }
    guard let loanAmount = loanAmount else {
        throw ValidationError(message: "loan amount not set")
    }
    guard let incomeDouble = Double(income), let loanAmountDouble = Double(loanAmount) else {
        throw ValidationError(message: "Income and loan amount must be numeric")
    }
    if incomeDouble < 0 || loanAmountDouble < 0 {
        throw ValidationError(message: "Income and loan amount must be positive")
    }
    if !isLoanRatioValid(income: incomeDouble, loanAmount: loanAmountDouble, loanToIncomeRatio: loanToIncomeRatio) {
        throw ValidationError(message: "Loan amount must be less than (\(loanToIncomeRatio) x Annual Income)")
    }
    
}

func isLoanRatioValid(income: Double, loanAmount: Double, loanToIncomeRatio: Double) -> Bool {
    if loanAmount > income * loanToIncomeRatio {
        return false
    } else {
        return true
    }
}
