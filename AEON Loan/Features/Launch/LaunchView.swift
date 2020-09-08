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
      
      viewModel.locationName.bind { [weak self] locationName in
        self?.label.text = locationName
      }
        
//        navigateToLogin()
        
        
    }
    
    
    func navigateToLogin() {
//        let login = LoginViewController.instantiate()
//        let controller = NavigationController.blue(with: login)
//        view.window?.setRootViewController(login)
        
        let selectLanguage = SelectLanguageViewController.instantiate()
        view.window?.setRootViewController(selectLanguage)
        
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
        navigateToLogin()
        
    }
    

}
