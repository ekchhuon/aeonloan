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
    
    let touchMe = BiometricIDAuth()
    var hidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPassword.text = NSLocalizedString("Forgot Password or passowrd?", comment: "")
        setupView()
        bind()
        setup(title: "Login")
        // startTouchID()
    }
    
    func startTouchID() {
      touchMe.authenticateUser() { [weak self] (status, message) in
        if let message = message {
            self?.showAlert(message: message)
        } else {
            self?.navigates(to: .home(.push(subtype: .fromLeft)))
        }
      }
    }
    
    private func bind() {
        viewModel.user.bind { (user) in
            
        }
        
        viewModel.loading.bind { (loading) in
            self.show(indicator: loading)
        }
        
        viewModel.token.bind { (token) in
            // self.showAlert(message: token)
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
            let username = try usernameTextField.validatedText(type:  .phone)
            let password = try passwordTextField.validatedText(type: .other(message: "Required"))
            let data = LoginDataTest(username: username, password: password)
            fetch(data)
        } catch (let error) {
            print((error as! ValidationError).message)
            showAlert(message: "\((error as! ValidationError).message)")
        }
    }
    
    func fetch(_ data: LoginDataTest) {
        
//        showAlert(message: "Success")
        navigates(to: .home(.push(subtype: .fromLeft)))
        
        // viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        // showAlert(title: "Success", message: "Hello World", buttonTitle: "Try again")
    }
}

struct LoginDataTest {
    var username: String
    var password: String
}




extension String {
    //    let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
    //    let phoneRegex = "[235689][0-9]{6}([0-9]{3})?"
    //    let phoneRegex = "0[1-9]{2}[0-9]{6}([0-9]{1})?"
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "0[1-9]{2}[0-9]{6}([0-9]{1})?"  //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    var isPhone: Bool {
        //012345678, 0123456789 or +85512345678
        let phoneRegex = "(0|\\+855)[1-9]{2}[0-9]{6}([0-9]{1})?"  //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isDigit: Bool {
        guard !self.isEmpty else { return false }
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        let password = NSPredicate(format: "SELF MATCHES %@", regex)
        return password.evaluate(with: self)
    }
}
