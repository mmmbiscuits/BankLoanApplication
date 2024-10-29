//
//  BankLoanApplicationTests.swift
//  BankLoanApplicationTests
//
//  Created by Ryan Smale on 25/10/2024.
//

import Testing
@testable import BankLoanApplication

struct BankLoanApplicationTests {

    @Test func checkHomeLoanCalculations() async throws {
        // expected exact match
        #expect(isLoanRatioValid(income: 100.0, loanAmount: 50.0, loanToIncomeRatio: 0.5) == true)
        // this should fail
        #expect(isLoanRatioValid(income: 100.0, loanAmount: 50.0, loanToIncomeRatio: 0.4) == false)
        
    }
    
    @Test func checkValidEmail() async throws {
        //valid
        #expect(isValidEmail("test@test.com"))
        //should fail
        #expect(!isValidEmail("@example.com"))
        
    }
    
    @Test func checkValidIRDNumber() async throws {
        // valid
        #expect(isValidIRDNumber("123-456-789"))
        #expect(isValidIRDNumber("000-000-000"))
        
        // should fail:
        // to many numbers, no hypens
        #expect(!isValidIRDNumber("1234567890"))
        //one number too short
        #expect(!isValidIRDNumber("12-345-678"))
        // non number in sequence
        #expect(!isValidIRDNumber("123-4X9-678"))
    }
    
    @Test func checkValidPhoneNumber() async throws {
        #expect(isValidPhoneNumber("0412345678"))
        #expect(isValidPhoneNumber("021 25 10 111"))
        #expect(isValidPhoneNumber("+64212510111"))
        #expect(isValidPhoneNumber("+64 21 25 10 111"))

    }

}
