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
    private let wviewModel = WeatherViewModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var farenheit: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.user.bind { (user) in
            print("callback user", user?.username)
        }
        
        wviewModel.locationName.bind { (location) in
            
            self.location.text = location
            print("callback location", location)
        }
        
        wviewModel.forecastSummary.bind { (forcast) in
            self.farenheit.text = forcast
            print("callback forcast", forcast)
        }
        
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
//        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        location.text = usernameTextField.text ?? ""
        location.backgroundColor = .blue
        wviewModel.changeLocation(to: usernameTextField.text ?? "")
    }
    
    func navigateToHome() {
        let login = HomeView.instantiate()
//        let controller = NavigationController.blue(with: login)
        self.present(login, animated: true, completion: {})
         
    }
    

}
