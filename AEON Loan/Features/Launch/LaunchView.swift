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
            self.navigates(to: .home(.push(subtype: .fromRight)))
        }
        
        
//        viewModel.locationName.bind { [weak self] locationName in
//            self?.label.text = locationName
//        }
        
        //        navigateToLogin()
        
//        navigateToHome()
        
        
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
        navigates(to: .home(.push(subtype: .fromRight)))
//        navigates(to: .language)
        
    }
    
    
}
