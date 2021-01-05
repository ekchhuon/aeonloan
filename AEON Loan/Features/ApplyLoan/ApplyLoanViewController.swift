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

class ApplyLoanViewController: BaseViewController, WriteValueBackDelegate {
    
    private let viewModel = ApplyLoanViewModel()
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
//    var hasCheckedCredit: Bool = false
    var product: CheckCredit.ProductOffer?
    var products: [CheckCredit.ProductOffer]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Apply Loan/Installment")
        submitButton.rounds(radius: 10, background: .brandPurple)
//        submitButton.setTitle( hasCheckedCredit ? "Submit": "Next", for: .normal)
//        submitButton.isHidden = true
        contactTextField.text = Preference.user.phoneNumber
        emailTextField.text = Preference.user.email
        amountTextField.delegate = self
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
            guard msg.contains("No data found") else {
                self.showAlert(title: "".localized ,message: msg)
                return
            }
            
            let alert = self.showAlt(title: "".localized, message: "Please check your credit before apply loan".localized, style: .alert)
            let okAction = UIAlertAction(title: "Check", style: .default) {_ in
                self.navigates(to: .checkCredit(.form(nil)))
            }
            alert.addAction(okAction)
            
//            let controller = CheckCreditMessageViewController.instantiate()
//            controller.modalPresentationStyle = .overCurrentContext
//            self.present(controller, animated: true)
            
//            let controller = CheckCreditMessageViewController.instantiate()
//            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        viewModel.products.bind { [weak self] (products) in
            guard let self = self else { return }
            self.products = products
        }
        
        viewModel.response.bind { [weak self] response in
            guard let self = self,
                  let resp = response, resp.body.success else { return }
            
            let controller = LoanSuccessViewController.instantiate()
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true)
        }
    }
    
    func writeBack(value: Any?) {
        if let value = value as? CheckCredit.ProductOffer {
            print("Value....", value)
            self.product = value
            productTextField.text = value.product
            amountTextField.placeholder = "Amount (upto USD \(value.fa))"
        }
    }
    
    @IBAction func productTypeButtonTapped(_ sender: Any) {
        
        
        guard let products = products else {
            debugPrint("No Product"); return
        }
        let controller = ProductPickerViewController.instantiate(products, product?.product ?? "")
        navigationController?.pushViewController(controller, animated: true)
        controller.writeBackDelegate = self
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        //        let controller = LoanSubmissionResultViewController.instantiate(result: .success)
        //        navigationController?.pushViewController(controller, animated: true)
        
        //        navigates(to: .loanResult(.success))
        
        validate { data in
//            guard self.hasCheckedCredit else  {
//                self.navigates(to: .checkCredit(.form(data))); return
//            }
            
            let amount = "\(self.amountTextField.text ?? "0")".asCurrency
            
            let alert = self.showAlt(title: "Apply Loan", message: "You're about to apply loan for \(self.productTextField.text ?? "") with the amount of USD \(amount) ", actionTitle: "Cancel".localized, style: .actionSheet, actionStyle: .cancel)
            let okAction = UIAlertAction(title: "Apply", style: .default) {_ in
                self.viewModel.submit(data: data)
            }
            alert.addAction(okAction)
        }
    }
    
    func validate(completion: @escaping (_ data: ApplyLoan) -> Void) {
        do {
            let phone = try contactTextField.validatedText(type: .phone)
            _ = try productTextField.validatedText(type: .requiredField(field: "Product Type"))
            let amount = try amountTextField.validatedText(type: .requiredField(field: "Amount"))
            let email = try emailTextField.validatedText(type: .email)
            let data = ApplyLoan(contactNumber: Int(phone) ?? 0, productTypeId: self.product?.id ?? "0", amount: amount.asDouble, email: email)
            completion(data)
        } catch (let error) {
            let error = (error as! ValidationError).message
            showAlert(message: error)
        }
    }
}

extension ApplyLoanViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        guard textField.text != "" else {return}
        textField.addTarget(self, action: #selector(valueChanged), for: .allEvents)
    }
    
    // Get value from textfield
    @objc func valueChanged(_ textField: UITextField){
//        amountTextField.text = "USD \(textField.text)"
        
//        print("Amount", textField.text)
        
    }
}


struct ApplyLoan: Codable {
    let contactNumber: Int
    let productTypeId: String
    let amount: Double
    let email: String
}
