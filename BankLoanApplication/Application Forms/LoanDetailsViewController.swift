//
//  LoanDetailsViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

class LoanDetailsViewController: UIViewController {

    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var irdNumberTextField: UITextField!
    
    @IBOutlet weak var validationErrorsLabel: UILabel!
    
    private var irdNumber: NSNumber?
    
    var validationErrors: [Error] = []
    
    private let loanToIncomeRatio: Double = 0.5
    
    var loanApplication: DraftLoanApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loan Details"
        // Do any additional setup after loading the view.
        incomeTextField.delegate = self
        loanAmountTextField.delegate = self
        irdNumberTextField.delegate = self
        
        populateTextFields()
    }
    
    func populateTextFields() {
        if let incomeString = loanApplication?.annualIncome {
            incomeTextField.text = String(incomeString.formatted())
        }
        if let loanAmountString = loanApplication?.loanAmount {
            loanAmountTextField.text = String(loanAmountString.formatted())
        }
        
        if let irdNumber = loanApplication?.irdNumber {
            irdNumberTextField.text = String(irdNumber)
        }
    }
    
    func populateModel() {
        if let incomeString = incomeTextField.text {
            loanApplication?.annualIncome = Double(incomeString)
        }
        if let loanAmountString = loanAmountTextField.text {
            loanApplication?.loanAmount = Double(loanAmountString)
        }
        
        if let irdNumberString = irdNumberTextField.text {
            loanApplication?.irdNumber = irdNumberString
        }
    }

    @IBAction func goToLoanSummaryButtonPressed(_ sender: Any) {
        
        //if all are valid
        if checkValidations() {
            populateModel()
            self.performSegue(withIdentifier: "loanApplicationSummarySegueID", sender: nil)
        }
        
        displayValidationErrors()
        
    }
    
    func displayValidationErrors() {
        //hide the label when we have no errors
        validationErrorsLabel.isHidden = validationErrors.isEmpty
        
        var errorsString = ""
        
        for error in validationErrors {
            if let validationError = error as? ValidationError {
                errorsString.append(contentsOf: validationError.message + "\n")
            } else {
                errorsString.append(contentsOf: error.localizedDescription + "\n")
            }
        }
        
        validationErrorsLabel.text = errorsString
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LoanApplicationSummaryViewController {
            destination.loanApplication = self.loanApplication
        }
    }

    func checkValidations() -> Bool {
        validationErrors = []
        do {
            try validateLoanRatio(income: incomeTextField.text, loanAmount: loanAmountTextField.text, loanToIncomeRatio: loanToIncomeRatio)
            try validateIRDNumber( irdNumberTextField.text)
        } catch {
            validationErrors.append(error)
        }
        
        return validationErrors.isEmpty
    }

    
}

extension LoanDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.displayValidity(valid: true)
        return true
    }
    
    // run validation after textfield edited.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
//        case incomeTextField:
//        case loanAmountTextField:
        case irdNumberTextField:
            do {
                try validateIRDNumber(textField.text)
            } catch {
                textField.displayValidity(valid: false)
            }
            
        default:
            return
        }
    }
    
    // helping user when returning to go to the next field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default :
            textField.resignFirstResponder()
        }
        return true
    }
    
}
