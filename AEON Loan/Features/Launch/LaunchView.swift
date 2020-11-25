//
//  LaunchView.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//



import UIKit

class LaunchView: UIViewController {
    private let viewModel = WeatherViewModel()
    
    @IBOutlet weak var label: UILabel!
    
    
    
    
    override func viewDidLoad() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.navigates(to: .home(.fade))
            
//            self.navigates(to: .login)
            self.navigates(to: .language)
            
        }
        
        Preference.user = MyUser(firstName: "Chhuon", lastName: "Ek")
        print("Before",Preference.user)
        
        Preference.reset(forKey: .user)
        print("After",Preference.user)

    }
    
    
    func navigateToLogin() {
        //        let login = LoginViewController.instantiate()
        //        let controller = NavigationController.blue(with: login)
        //        view.window?.setRootViewController(login)
        
        //        let selectLanguage = SelectLanguageViewController.instantiate()
        //        view.window?.setRootViewController(selectLanguage)
        
        navigates(to: .language)
        
    }
    
    func navigateToHome() {
        let home = HomeViewController.instantiate()
        let controller = NavigationController.main(with: home)
        view.window?.setRootViewController(controller)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func tapped(_ sender: Any) {
        
        //        navigateToLogin()
        //        navigateToHome()
//        navigates(to: .home(.push(subtype: .fromRight)))
//        navigates(to: .language)
        
//        navigates(to: .login)
        
        
        
    }
    
    
}
