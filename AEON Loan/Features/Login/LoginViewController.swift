//
//  LoginViewController.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import UIKit

extension LoginViewController {
    static func instantiate() -> LoginViewController {
        return LoginViewController()
    }
}

class LoginViewController: BaseViewController {
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var eyeballButton: UIButton!
    
    
    var hidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPassword.text = NSLocalizedString("Forgot Password or passowrd?", comment: "")
        
        setupView()
        bind()
        setup(title: "Login")
    }
    
    private func bind() {
        viewModel.user.bind { (user) in
            
        }
        
        viewModel.loading.bind { (loading) in
            self.show(indicator: loading)
        }
        
        viewModel.token.bind { (token) in
//            self.showAlert(message: token)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        validate()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        navigates(to: .register)
    }
    
    @IBAction func eyeButtonTapped(_ sender: Any) {
        hidden = !hidden
        let eyeball = UIImage(systemName: hidden ? "eye.slash" : "eye")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        eyeballButton.setImage(eyeball, for: .normal)
        passwordTextField.isSecureTextEntry = hidden
    }
    
    
    @IBOutlet weak var forgotPassword: UILabel!
    
    
    
    func navigateToHome() {
//        let login = HomeView.instantiate()
//        let controller = NavigationController.blue(with: login)
//        self.present(login, animated: true, completion: {})
    }
    
    private func setupView(){
        setup(title: "Login".localized)
        setupTextField()
        
        loginButton.rounds(radius: 10, background: .brandPurple, border: .brandPurple, width: 1)
        registerButton.rounds(radius: 10, background: .brandYellow, border: .brandYellow, width: 1)
    }
    
    func setupTextField() {
        usernameTextField.placeholder = "Username/Phone Number".localized
        passwordTextField.placeholder = "Password".localized
        passwordTextField.isSecureTextEntry = true
        eyeballButton.setImage(UIImage(systemName: "eye.slash")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    func validate() {
        do {
            let username = try usernameTextField.validatedText(type: .username)
            let password = try passwordTextField.validatedText(type: .username)
            let data = LoginDataTest(username: username, password: password)
            fetch(data)
        } catch (let error) {
            print((error as! ValidationError).message)
        }
    }
    
    func fetch(_ data: LoginDataTest) {
         viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
//        showAlert(title: "Success", message: "Hello World", buttonTitle: "Try again")
    }
}

struct LoginDataTest {
    var username: String
    var password: String
}




