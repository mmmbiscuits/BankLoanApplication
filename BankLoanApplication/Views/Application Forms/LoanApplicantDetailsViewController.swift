//
//  LoanApplicantDetailsViewController.swift
//  BankLoanApplication
//
//  Created by Ryan Smale on 25/10/2024.
//

import UIKit

protocol LoanDetailsViewControllerDelegate: AnyObject {
    func updatedLoanApplication(didUpdate loanApplicationVM: LoanApplicationViewModel)
}

class LoanApplicantDetailsViewController: KeyboardRespondingViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
        
    @IBOutlet weak var validationErrorsLabel: UILabel!
    
    var viewModel: LoanApplicationViewModel!
    
    let genderPicker: UIPickerView = UIPickerView()
        
    @IBOutlet weak var proceedToLoanDetailsButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBAction func unwindToApplicantDetails( _ segue: UIStoryboardSegue) {}
    
    func populateTextFields() {
        fullNameTextField.text = viewModel.loanApplication.fullName
        emailTextField.text = viewModel.loanApplication.email
        phoneNumberTextField.text = viewModel.loanApplication.phoneNumber
        genderTextField.text = viewModel.loanApplication.gender
        addressTextField.text = viewModel.loanApplication.address
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Applicant Details"
        // Do any additional setup after loading the view
        
        if viewModel == nil {
            viewModel = LoanApplicationViewModel(loanApplication: DraftLoanApplication())
        }
        
        fullNameTextField.delegate = self
        fullNameTextField.tag = TextfieldTag.fullName.rawValue
        emailTextField.delegate = self
        emailTextField.tag = TextfieldTag.email.rawValue
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = TextfieldTag.phoneNumber.rawValue
        addressTextField.delegate = self
        addressTextField.tag = TextfieldTag.address.rawValue
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.delegate = self
        genderTextField.tag = TextfieldTag.gender.rawValue
        self.genderTextField.inputView = genderPicker
        
        self.scrollView.delegate = self
        self.scrollView.keyboardDismissMode = .onDrag
       
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
            
    @IBAction func goToLoanDetailsButtonPressed(_ sender: Any) {
        do {
            try viewModel.areUserFieldValid()
            self.performSegue(withIdentifier: "goToLoanDetailsSegueId", sender: nil)
        } catch {
            displayValidationErrors()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //update our data
        
        //pass it to the next view
        if let destination = segue.destination as? LoanDetailsViewController {
            destination.viewModel = self.viewModel
            destination.delegate = self
        }
        
        if let destination = segue.destination as? LoanApplicationsTableViewController, segue.identifier == SegueIdentifiers.unwindAndSaveSegueIdentifier.rawValue {
            destination.saveOrUpdateLoanApplication(viewModel.loanApplication, isDraft: true)
        }
    }
    
    // MARK: - Showing errors
    func displayValidationErrors() {
        //hide the label when we have no errors
        var errorsString = ""
        for field in viewModel.fieldsWithErrors {
            //checking its one of our errors
            if viewModel.loanFields.contains([field.textfieldTag]) {
                //highlight in red the textfield
                textfieldDisplayError(textField: field.textfieldTag, showIssue: true)
                //add its issue to the list
                if let validationError = field.error as? ValidationError {
                    errorsString.append(contentsOf: validationError.message + "\n")
                } else {
                    errorsString.append(contentsOf: field.error.localizedDescription + "\n")
                }
            }
        }
    }
    
    func textfieldDisplayError(textField:TextfieldTag, showIssue: Bool) {
        switch textField {
            case .fullName:
            fullNameTextField.displayValidity(valid: showIssue)
            case .email:
            emailTextField.displayValidity(valid: showIssue)
            case .phoneNumber:
            phoneNumberTextField.displayValidity(valid: showIssue)
            case .gender:
            genderTextField.displayValidity(valid: showIssue)
            case .address:
            addressTextField.displayValidity(valid: showIssue)
            default :
            print("textfield display error this view shouldn't fire ")
        }
    }
    
    @objc func cancelButtonPressed() {
        self.presentDismissAlert()
    }
    
    @IBAction func fullNameTextFieldChanged(_ sender: Any) {
        viewModel.setFullName(fullNameTextField.text)
        //clearing the red on edit.
        textfieldDisplayError(textField: .fullName, showIssue: false)
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
        let selectedGender = GenderOptions.allCases[row].rawValue
        viewModel.setGender(selectedGender)
        genderTextField.text = selectedGender
        genderTextField.resignFirstResponder()
    }
    
}

extension LoanApplicantDetailsViewController: UITextFieldDelegate, UIScrollViewDelegate {
    //clearing any existing validation display
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == genderTextField, let text = genderTextField.text, text.isEmpty{
            genderTextField.text = GenderOptions.allCases.first?.rawValue
        }
        scrollView.scrollRectToVisible(textField.frame, animated: true)
        textField.displayValidity(valid: true)
        return true
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case fullNameTextField:
            viewModel.testValidation(validate: true, textfieldTag: .fullName)
        case emailTextField:
            viewModel.testValidation(validate: true, textfieldTag: .email)
        case phoneNumberTextField:
            viewModel.testValidation(validate: true, textfieldTag: .phoneNumber)
        case genderTextField:
            viewModel.testValidation(validate: true, textfieldTag: .gender)
        default :
            return ()
        }
    }
}

extension LoanApplicantDetailsViewController: LoanDetailsViewControllerDelegate {
    func updatedLoanApplication(didUpdate loanApplicationVM: LoanApplicationViewModel) {
        self.viewModel = loanApplicationVM
    }
}
 
