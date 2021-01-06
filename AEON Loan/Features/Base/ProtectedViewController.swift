//
//  ProtectedViewController.swift
//  AEON Loan
//
//  Created by aeon on 1/6/21.
//

import UIKit

extension ProtectedViewController {
    static func instantiate() -> ProtectedViewController {
        let controller = ProtectedViewController()
//        controller.item = item
        return controller
    }
}

class ProtectedViewController: UIViewController {
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signinButton.rounds(radius: 10)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signinButtonTapped(_ sender: Any) {
//        navigates(to: .login)
        self.dismiss(animated: true) {
            let controller = LoginViewController.instantiate()
            controller.modalTransitionStyle = .crossDissolve
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func learnMoreButtonTapped(_ sender: Any) {
        print("learn more")
        let home = LoginViewController.instantiate()
        let controller = NavigationController.main(with: home)
        view.window?.setRootViewController(controller)
        
        self.dismiss(animated: true) {
//            self.navigates(to: .login)
            
//            let controller = LoginViewController.instantiate()
//            controller.modalTransitionStyle = .crossDissolve
//            controller.modalPresentationStyle = .overFullScreen
//            self.present(controller, animated: true, completion: nil)
        }
    }
    
}


