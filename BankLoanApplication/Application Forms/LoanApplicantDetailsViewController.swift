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
        
    @IBOutlet weak var proceedToLoanDetailsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Applicant Details"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToLoanDetailsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToLoanDetailsSegueId", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
