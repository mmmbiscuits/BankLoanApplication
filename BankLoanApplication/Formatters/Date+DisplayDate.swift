
//
//  Date+DisplayDate.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import Foundation

extension Date {
    func shortDateDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
