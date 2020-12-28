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
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberLabel.text = "Enter OTP code sent to your number \n \(user.phoneNumber)"
        otpTextField.textContentType = .oneTimeCode
        otpTextField.delegate = self
        verifyButton.rounds(radius: 10)
        otpTextField.becomeFirstResponder()
        bind()
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "OTP Verification".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "OTP Verification".localized, message: err.localized)
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
    
    func validate(completion: @escaping (_ valid: String) -> Void) {
        do {
            let otpCode = try otpTextField.validatedText(type: .otp)
            completion(otpCode)
        } catch (let error) {
            print((error as! ValidationError).message)
            showAlert(message: "\((error as! ValidationError).message)")
        }
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        viewModel.requestOTP()
    }
    
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        validate { otp in
            self.viewModel.verifyOTP(otp: otp) { [weak self] _ in
                guard let self = self else {return}
                self.loginViewModel.login(username: self.user.fullname, password: self.user.password) { _ in
                    self.navigates(to: .home(.push(subtype: .fromLeft)))
                }
            }
        }
    }
}
