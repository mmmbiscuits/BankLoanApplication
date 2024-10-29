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
    
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    @IBOutlet weak var editApplicantDetailsButton: UIButton!
    @IBOutlet weak var editLoanDetailsButton: UIButton!
    
    @IBOutlet var LoanSubmissionView: UIView!
    
    @IBOutlet weak var submissionImage: UIImageView!
    @IBOutlet weak var submissionText: UILabel!
    
    var loanApplication: DraftLoanApplication?
    
    var summaryState: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Application Summary"
        // Do any additional setup after loading the view.
        submitButtonOutlet.isHidden = summaryState

        if summaryState {
            editLoanDetailsButton.isHidden = true
            editApplicantDetailsButton.isHidden = true
        }
        
        if summaryState && loanApplication?.submittedDate == nil {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))]
            
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(cancelButtonPressed))        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        if let editDestination = segue.destination as? UINavigationController, let loanApplication = loanApplication {
            if let LoanApplicationDetails = editDestination.topViewController as? LoanApplicantDetailsViewController {
                LoanApplicationDetails.viewModel = LoanApplicationViewModel(loanApplication: loanApplication)
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
  
        self.navigationController?.isNavigationBarHidden = true

        if  let windowFrame = view.window?.windowScene?.windows.first?.frame {
            self.LoanSubmissionView.frame = windowFrame
        }

        self.view.insertSubview(self.LoanSubmissionView, aboveSubview: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            if let image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate) {
                self.submissionImage.setSymbolImage(image, contentTransition: .replace)
            }
            self.submissionText.text = "Submitted"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.performSegue(withIdentifier: SegueIdentifiers.submitAndUnwindSegueIdentifier.rawValue, sender: self)
            })
            
        }
                
    }
    
    @objc func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "editLoanApplicationSegueID", sender: sender)
    }

    @objc func cancelButtonPressed(_ sender: Any) {
        self.presentDismissAlert()
    }
    @IBAction func editApplicantDetailsPressed(_ sender: Any) {
        
    }
    @IBAction func editLoanDetailsPressed(_ sender: Any) {
        
    }
}
