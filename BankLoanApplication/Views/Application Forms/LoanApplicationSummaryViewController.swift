//
//  LoanApplicationSummaryViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

class LoanApplicationSummaryViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var irdNumberLabel: UILabel!
    
    @IBOutlet weak var submittedDateLabel: UILabel!
    
    var loanApplication: DraftLoanApplication?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Application Summary"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonPressed))]
        populateLabels()
    }
    
    func populateLabels() {
        guard let loanApplication else { return }
        
        nameLabel.text = loanApplication.fullName
        emailLabel.text = loanApplication.email
        phoneNumberLabel.text = loanApplication.phoneNumber
        genderLabel.text = loanApplication.gender
        addressLabel.text = loanApplication.address
        
        if let income = loanApplication.annualIncome {
            incomeLabel.text = "$\(income)"
        }
        if let loanAmount = loanApplication.loanAmount {
            loanAmountLabel.text = "$\(loanAmount)"
        }
        irdNumberLabel.text = loanApplication.irdNumber
        
        if let submittedDate = loanApplication.submittedDate {
            submittedDateLabel.text = submittedDate.formatted(date: .abbreviated, time: .shortened)
        } else {
            submittedDateLabel.text = "Draft"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
        // Unwinding and saving progress
        if let destination = segue.destination as? LoanApplicationsTableViewController, let loanApplication = loanApplication {
            destination.saveOrUpdateLoanApplication(loanApplication, isDraft: segue.identifier == SegueIdentifiers.unwindAndSaveSegueIdentifier.rawValue)
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.submitAndUnwindSegueIdentifier.rawValue, sender: self)
    }

    @objc func cancelButtonPressed(_ sender: Any) {
        self.presentDismissAlert()
    }
}
