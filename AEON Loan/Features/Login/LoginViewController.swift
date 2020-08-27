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
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var farenheit: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.user.bind { (user) in
            self.location.text = user?.username
            self.farenheit.text = user?.password
        }
        
        viewModel.loading.bind { (loading) in
            self.show(indicator: loading)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    func navigateToHome() {
        let login = HomeView.instantiate()
//        let controller = NavigationController.blue(with: login)
        self.present(login, animated: true, completion: {})
         
    }
    

}


