//
//  LoanDetailsViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

class LoanDetailsViewController: KeyboardRespondingViewController {

    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var irdNumberTextField: UITextField!
    
    @IBOutlet weak var validationErrorsLabel: UILabel!
    
    @IBAction func unwindToLoanDetails( _ segue: UIStoryboardSegue) {}

    weak var delegate: LoanDetailsViewControllerDelegate?
    
    private var irdNumber: NSNumber?
    
    var validationErrors: [Error] = []
    
    var viewModel: LoanApplicationViewModel!
    
    var loanApplication: DraftLoanApplication?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loan Details"
        // Do any additional setup after loading the view.
        incomeTextField.delegate = self
        loanAmountTextField.delegate = self
        irdNumberTextField.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(cancelButtonPressed))
        populateTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterForKeyboardNotifications()
    }
    
    func populateTextFields() {
        if let incomeString = loanApplication?.annualIncome {
            incomeTextField.text = String(incomeString)
        }
        if let loanAmountString = loanApplication?.loanAmount {
            loanAmountTextField.text = String(loanAmountString)
        }
        
        if let irdNumber = loanApplication?.irdNumber {
            irdNumberTextField.text = String(irdNumber)
        }
    }
    
    @IBAction func goToLoanSummaryButtonPressed(_ sender: Any) {
        
        //if all are valid
        
        if viewModel.areAllFieldsValid() {
            self.performSegue(withIdentifier: SegueIdentifiers.showLoanDetailsSegueIdentifier.rawValue, sender: nil)

        }
        displayValidationErrors()
        
        
    }
    
    func displayValidationErrors() {
        //hide the label when we have no errors
        validationErrorsLabel.isHidden = viewModel.fieldsWithErrors.isEmpty
        
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
        // Unwinding and saving progress
        if let destination = segue.destination as? LoanApplicationsTableViewController, let loanApplication = loanApplication, segue.identifier == SegueIdentifiers.unwindAndSaveSegueIdentifier.rawValue {
            destination.saveOrUpdateLoanApplication(loanApplication, isDraft: true)
        }
    }
    
    @objc func cancelButtonPressed () {
        self.presentDismissAlert()
    }
    
}

extension LoanDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.displayValidity(valid: true)
        return true
    }
    
    // run validation after textfield edited.
    func textFieldDidEndEditing(_ textField: UITextField) {
        //update model
        populateModel()
        //delegate it back
        if let loanApplication = loanApplication {
            self.delegate?.updatedLoanApplication(didUpdate: loanApplication)
        }
        
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



