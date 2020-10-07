//
//  RegisterViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit
import BCryptSwift

extension RegisterViewController {
    static func instantiate() -> RegisterViewController {
        return RegisterViewController()
    }
}

class RegisterViewController: BaseViewController {
    private let viewModel = RegisterViewModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var eyeballButtons: [UIButton]!
    
    var secured: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func bind() {
        viewModel.loading.bind { (loading) in
            self.show(indicator: loading)
        }
        
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err  else { return }
            self.showAlert(title: "\(err.code) \(err.description) ", message: "\(err.localized)")
        }
        
//        viewModel.success.bind { (success) in
//
//            self.showAlert(message: success)
//        }
        
        viewModel.success.bind { [weak self] msg in
            guard let self = self, !msg.isEmpty else { return }
            self.showAlert(message: msg)
        }
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
//        navigates(to: .home(.push(subtype: .fromLeft)))
//        navigates(to: .OTP)
        validate()
    }
    
    @IBAction func passwordEyeballTapped(_ sender: Any) {
        showPassword(at: 0)
    }
    
    @IBAction func confirmPasswordEyeballTapped(_ sender: Any) {
        showPassword(at: 1)
    }
    
    func showPassword(at index: Int) {
        secured = !secured
        let eyeball = UIImage(systemName: secured ? "eye.slash" : "eye")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        let passwordFields = [passwordTextField, confirmPasswordTextField]
        eyeballButtons[index].setImage(eyeball, for: .normal)
        passwordFields[index]?.isSecureTextEntry = secured
    }
    
    
    
    func navigateToHome() {
//        let login = HomeView.instantiate()
//        let controller = NavigationController.blue(with: login)
//        self.present(login, animated: true, completion: {})
    }
    
    private func setupView(){
        setup(title: NSLocalizedString("Register", comment: ""))
        setupTextField()
        registerButton.rounds(radius: 10, background: .brandPurple, border: .brandPurple, width: 1)
    }
    
    func setupTextField() {
        let textFields = [usernameTextField, phoneTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        let placeholders = ["Username", "Phone Number", "Email Adress", "Password", "Confirm Password"]
        let eyeball = UIImage(systemName: "eye.slash")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        
        for (index, field) in textFields.enumerated() {
            field?.placeholder = NSLocalizedString(placeholders[index], comment: "")
        }
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        eyeballButtons.forEach { $0.setImage(eyeball, for: .normal) }
        textFields.forEach { $0?.autocorrectionType = .no}
    }
    
    func validate() {
        do {
            let username = try usernameTextField.validatedText(type: .username)
            let phone = try phoneTextField.validatedText(type: .username)
            let email = try emailTextField.validatedText(type: .requiredField(field: "Helloooo.."))
            let password = try passwordTextField.validatedText(type: .username)
            let confirm = try confirmPasswordTextField.validatedText(type: .username)

            guard password == confirm else {
                showAlert(message: "Password Mismatched")
                return
            }
            
            let data = Param.Register(username: username, phone: phone, email: email, password: password)
            fetch(with: data)
        } catch (let error) {
            showAlert(message: (error as! ValidationError).message)
        }
    }
    
    func fetch(with param: Param.Register) {
        viewModel.register(with: param)
        
//        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        //        showAlert(title: "Success", message: "Hello World", buttonTitle: "Try again")
    }
}





