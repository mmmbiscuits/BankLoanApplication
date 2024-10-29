//
//  LoanApplication+PopulateFromDraftLoanApplication.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 29/10/2024.
//

extension LoanApplication {
    func populateWithDraft(_ draft: DraftLoanApplication) {
        self.fullName = draft.fullName
        self.emailAddress = draft.email
        self.phoneNumber = draft.phoneNumber
        self.address = draft.address
        self.gender = draft.gender
        
        if let loanAmount = draft.loanAmount {
            self.loanAmount = loanAmount
        }
        if let annualIncome = draft.annualIncome {
            self.annualIncome = annualIncome
        }
        self.irdNumber = draft.irdNumber
        self.submittedDate = draft.submittedDate
        
    }
}
