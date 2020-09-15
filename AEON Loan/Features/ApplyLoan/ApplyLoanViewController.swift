//
//  ApplyLoanViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/11/20.
//

import UIKit

extension ApplyLoanViewController {
    static func instantiate() -> ApplyLoanViewController {
        return ApplyLoanViewController()
    }
}

class ApplyLoanViewController: BaseViewController {
    private let viewModel = ApplyLoanViewModel()
    
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let controller = LoanSubmissionResultViewController.instantiate(isCheckCredit: false)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ApplyLoanViewController {
    func setupView() {
        setup(title: NSLocalizedString("Apply Loan/Installment", comment: ""))
        setupTextFields()
        submitButton.rounds(radius: 10, background: .brandPurple)
    }
    
    func setupTextFields(){
        let textFields = [contactTextField, productTextField, emailTextField, amountTextField, locationTextField]
        let placeholders = ["Contact Number", "Product Type", "Email Address", "Amount", "Location"]
        
        for (index, item) in textFields.enumerated() {
            item?.placeholder = NSLocalizedString(placeholders[index], comment: "")
        }
    }
}
