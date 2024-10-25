//
//  BankLoanApplicationTests.swift
//  BankLoanApplicationTests
//
//  Created by Ryan Smale on 25/10/2024.
//

import Testing
@testable import BankLoanApplication

struct BankLoanApplicationTests {

    
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

}
