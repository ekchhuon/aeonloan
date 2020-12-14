//
//  OTPViewController.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import UIKit

extension OTPViewController {
    static func instantiate(user: User) -> OTPViewController {
        let controller = OTPViewController()
        controller.user = user
        return controller
    }
}

class OTPViewController: BaseViewController, UITextFieldDelegate {
    private let viewModel = OTPViewModel()
    private let loginViewModel = LoginViewModel()
    private var user = User()
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var otpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.textContentType = .oneTimeCode
        textFields.forEach {
            $0.setBorder(5, border: .white, width: 1)
            $0.delegate = self
            $0.textContentType = .oneTimeCode
            $0.keyboardType = .numberPad
            $0.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        }
        bind()
//        textFields[0].becomeFirstResponder()
        
        otpTextField.becomeFirstResponder()
        
        print("OTP USer=====>", user)
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
        
        loginViewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        loginViewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Login".localized ,message: msg)
        }
        loginViewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Login".localized, message: err.localized)
        }
    }
    
    func validOTP(value: String) {
        showAlert(message: "Valid \(value)")
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if otpTextField.text?.count == 6 {
            

        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if otpTextField.text?.count == 6 {
            viewModel.verifyOTP(otp: otpTextField.text ?? "") { [weak self] _ in
                guard let self = self else {return}
                self.loginViewModel.login(username: self.user.username, password: self.user.password) { _ in
                    self.navigates(to: .home(.push(subtype: .fromLeft)))
                }
            }
        }
    }
    
    
    /*
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        let first = textFields[0], second = textFields[1], third = textFields[2], fourth = textFields[3]

        if  text?.count == 1 {
            switch textField{
            case first:
                second.becomeFirstResponder()
            case second:
                third.becomeFirstResponder()
            case third:
                fourth.becomeFirstResponder()
            case fourth:
                fourth.resignFirstResponder()
            default:
                break
            }
        }
        
        if text?.count == 0 {
            switch textField{
            case first:
                first.becomeFirstResponder()
            case second:
                first.becomeFirstResponder()
            case third:
                second.becomeFirstResponder()
            case fourth:
                third.becomeFirstResponder()
            default:
                break
            }
        } else{}
        
        let values = [first.text!, second.text!, third.text!, fourth.text! ].filter { $0 != "" }
        if values.count == 4 {
            let value = values.joined(separator: "")
            validOTP(value: value)
        }
        
    }
    */
}
