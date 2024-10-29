
//
//  Date+DisplayDate.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import Foundation

extension Date {
    func stylisedDateDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy \n h:mm a"
        return dateFormatter.string(from: self)
    }
}
