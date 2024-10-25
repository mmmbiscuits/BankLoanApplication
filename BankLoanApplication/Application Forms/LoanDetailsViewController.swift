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
    
    private let loanToIncomeRatio: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loan Details"
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToLoanSummaryButtonPressed(_ sender: Any) {
        
        //if all are valid
        
        //else
        
        self.performSegue(withIdentifier: "loanApplicationSummarySegueID", sender: nil)
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
