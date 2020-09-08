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

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var eyeUIImage: UIImageView!
    
    var hidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func bind() {
        viewModel.user.bind { (user) in
            
        }
        
        viewModel.loading.bind { (loading) in
            self.show(indicator: loading)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {

        
    }
    
    @IBAction func eyeButtonTapped(_ sender: Any) {
        hidden = !hidden
        eyeUIImage.image = UIImage(systemName: hidden ? "eye.slash" : "eye")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        passwordTextField.isSecureTextEntry = hidden
    }
    
    
    
    
    func navigateToHome() {
//        let login = HomeView.instantiate()
//        let controller = NavigationController.blue(with: login)
//        self.present(login, animated: true, completion: {})
    }
    
    private func setupView(){
        usernameTextField.placeholder = "Username / Phone Number"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        eyeUIImage.image = UIImage(systemName: "eye.slash")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        
        loginButton.rounds(radius: 10, border: .brandPurple, background: .brandPurple, width: 1)
        registerButton.rounds(radius: 10, border: .brandYellow, background: .brandYellow, width: 1)
        
    }
}




