//
//  RegisterViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit

extension RegisterViewController {
    static func instantiate() -> RegisterViewController {
        return RegisterViewController()
    }
}

class RegisterViewController: BaseViewController {
//    private let viewModel = LoginViewModel()
    
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
//        viewModel.user.bind { (user) in
//
//        }
//
//        viewModel.loading.bind { (loading) in
//            self.show(indicator: loading)
//        }
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
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
        registerButton.rounds(radius: 10, border: .brandPurple, background: .brandPurple, width: 1)
    }
    
    func setupTextField() {
        usernameTextField.placeholder = NSLocalizedString("Username", comment: "")
        phoneTextField.placeholder = NSLocalizedString("Email Address", comment: "")
        emailTextField.placeholder = NSLocalizedString("Email Address", comment: "")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
        confirmPasswordTextField.placeholder = NSLocalizedString("Confirm Password", comment: "")
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        let eyeball = UIImage(systemName: "eye.slash")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        eyeballButtons.forEach { $0.setImage(eyeball, for: .normal) }
    }
}




