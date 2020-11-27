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
            
//            if Preference.language == .none {
//                self.navigates(to: .language)
//            } else {
//                self.navigates(to: .home(.fade))
//            }
            
            self.navigates(to: .home(.fade))
        }
        
        Preference.user = MyUser(firstName: "Chhuon", lastName: "Ek")
        print("Before",Preference.user)
        
        Preference.reset(forKey: .user)
        print("After",Preference.user)

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
          
    }
    
    
}
