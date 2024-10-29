//
//  LoanApplicationTableViewCell.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

class LoanApplicationTableViewCell: UITableViewCell {

    @IBOutlet weak var applicantNameLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var submissionStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func populateWithApplication(_ application: LoanApplication) {
        applicantNameLabel.text = "Applicant: " + (application.fullName ?? "Unknown")
        loanAmountLabel.text = "Loan Amount: $" + application.loanAmount.formatted()
        submissionStateLabel.text = application.submittedDate?.shortDateDisplay() ?? "Draft"
    }
}
