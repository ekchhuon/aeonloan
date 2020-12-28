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
    @IBOutlet weak var submitButton: UIButton!
    
    var hasCheckedCredit: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        submitButton.setTitle( hasCheckedCredit ? "Submit": "Next", for: .normal)
        submitButton.isHidden = true
        contactTextField.text = Preference.user.phoneNumber
        emailTextField.text = Preference.user.email
        
        print(Preference.user)
        
        bind()
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Login".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Login".localized, message: err.localized)
        }
        viewModel.response.bind { [weak self] (result) in
            guard let self = self else { return }
            self.submitButton.isHidden = false
            
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        //        let controller = LoanSubmissionResultViewController.instantiate(result: .success)
        //        navigationController?.pushViewController(controller, animated: true)
        
        //        navigates(to: .loanResult(.success))
        
        validate { data in
            guard self.hasCheckedCredit else  {
                self.navigates(to: .checkCredit(.form(data))); return
            }
            self.viewModel.submit(data: data)
        }
        
    }
    
    func validate(completion: @escaping (_ data: ApplyLoan) -> Void) {
        do {
            let phone = try contactTextField.validatedText(type: .phone)
            let product = try productTextField.validatedText(type: .requiredField(field: "Product Type"))
            let amount = try amountTextField.validatedText(type: .requiredField(field: "Amount"))
            let email = try emailTextField.validatedText(type: .email)
            let data = ApplyLoan(phone: phone, productType: product, amount: amount, email: email)
            completion(data)
        } catch (let error) {
            let error = (error as! ValidationError).message
            showAlert(message: error)
        }
    }
}

extension ApplyLoanViewController {
    func setupView() {
        setup(title: NSLocalizedString("Apply Loan/Installment", comment: ""))
        submitButton.rounds(radius: 10, background: .brandPurple)
    }
}

struct ApplyLoan: Codable {
    let phone, productType, amount, email: String
}
