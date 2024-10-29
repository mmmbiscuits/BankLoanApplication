//
//  LoanApplicantDetailsViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

class LoanApplicantDetailsViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
        
    @IBOutlet weak var validationErrorsLabel: UILabel!
    
    
    var loanApplication: DraftLoanApplication?
    
    let genderPicker: UIPickerView = UIPickerView()
        
    @IBOutlet weak var proceedToLoanDetailsButton: UIButton!
    
    var validationErrors: [Error] = []
    
    func updateLoanApplication() {
        loanApplication?.fullName = fullNameTextField.text
        loanApplication?.email = emailTextField.text
        loanApplication?.phoneNumber = phoneNumberTextField.text
        loanApplication?.gender = genderTextField.text
        loanApplication?.address = addressTextField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Applicant Details"
        // Do any additional setup after loading the view
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.genderTextField.inputView = genderPicker
        
        if loanApplication == nil {
            loanApplication = DraftLoanApplication()
        }
    }
    
    @IBAction func goToLoanDetailsButtonPressed(_ sender: Any) {
        if allValidationsMet() {
            self.performSegue(withIdentifier: "goToLoanDetailsSegueId", sender: nil)
        }
        displayValidationErrors()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //update our data
        updateLoanApplication()
        
        //pass it to the next view
        if let destination = segue.destination as? LoanDetailsViewController {
            destination.loanApplication = self.loanApplication
        }
        
    }
    
    func allValidationsMet() -> Bool {
        // clear the array
        validationErrors = []
        
        do {
            try validateFullName(fullNameTextField.text)
            try validateEmail(emailTextField.text)
            try validatePhoneNumber(phoneNumberTextField.text)
            try validateGender(genderTextField.text)
        } catch {
            validationErrors.append(error)
        }
        
        return validationErrors.isEmpty
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
    
    @objc func cancelButtonPressed () {
        
    }
    
}

extension LoanApplicantDetailsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum GenderOptions: String, CaseIterable {
        case  female = "Female", male = "Male", nonBinary = "Non-Binary"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenderOptions.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenderOptions.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = GenderOptions.allCases[row].rawValue
        genderTextField.resignFirstResponder()
    }
}

extension LoanApplicantDetailsViewController: UITextFieldDelegate {
    //clearing any existing validation display
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.displayValidity(valid: true)
        return true
    }
    
    // run validation after textfield edited.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case fullNameTextField:
            do {
                try validateFullName(fullNameTextField.text)
            } catch {
                fullNameTextField.displayValidity(valid: false)
            }
        case emailTextField:
            do {
                try validateEmail(emailTextField.text)
            } catch {
                emailTextField.displayValidity(valid: false)
            }
        case phoneNumberTextField:
            do {
                try validatePhoneNumber(phoneNumberTextField.text)
            } catch {
                textField.displayValidity(valid: false)
            }
        case genderTextField:
            do {
                try validateGender(genderTextField.text)
            } catch {
                genderTextField.displayValidity(valid: false)
            }
        default:
            return
        }
    }
    
    // helping user when returning to go to the next field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            genderTextField.becomeFirstResponder()
        default :
            textField.resignFirstResponder()
        }
        return true
    }
}
 