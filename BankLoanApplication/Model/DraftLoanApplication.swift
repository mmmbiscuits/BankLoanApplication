//
//  LoanApplication.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 29/10/2024.
//

import UIKit
import CoreData

class DraftLoanApplication: NSObject {
    
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var address: String?
    var gender: String?
    
    var loanAmount: Double?
    var annualIncome: Double?
    var irdNumber: String?
    
    var submittedDate: Date?
    var uuid: UUID?
    
    func populateCoreDataVersion(forContext context: NSManagedObjectContext) -> LoanApplication {
        
        let loanApplication = LoanApplication(context: context)
        loanApplication.fullName = self.fullName
        loanApplication.emailAddress = self.email
        loanApplication.phoneNumber = self.phoneNumber
        loanApplication.address = self.address
        loanApplication.gender = self.gender
        
        loanApplication.loanAmount = self.loanAmount ?? 0.0
        loanApplication.annualIncome = self.annualIncome ?? 0.0
        loanApplication.irdNumber = self.irdNumber
        loanApplication.submittedDate = self.submittedDate
        
        return loanApplication
        
    }
    init(loanApplication: LoanApplication) {
        self.fullName = loanApplication.fullName
        self.email = loanApplication.emailAddress
        self.phoneNumber = loanApplication.phoneNumber
        self.address = loanApplication.address
        self.gender = loanApplication.gender
        
        self.loanAmount = loanApplication.loanAmount
        self.annualIncome = loanApplication.annualIncome
        self.irdNumber = loanApplication.irdNumber
        
        self.submittedDate = loanApplication.submittedDate
        self.uuid = loanApplication.uuid
    }
    
    override init() {
        super.init()
    }
    
}
