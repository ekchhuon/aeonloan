//
//  CheckCreditMessageViewController.swift
//  AEON Loan
//
//  Created by aeon on 1/5/21.
//

import UIKit

extension CheckCreditMessageViewController {
    static func instantiate() -> CheckCreditMessageViewController {
        return CheckCreditMessageViewController()
    }
}

class CheckCreditMessageViewController: UIViewController {
    @IBOutlet weak var checkCreditButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCreditButton.rounds(radius: 10)
    }
    @IBAction func checkCreditButtonTapped(_ sender: Any) {
//        navigates(to: .checkCredit(.form(nil)))
//        navigates(to: .login)
        
//        let controller = CheckCreditFormViewController.instantiate(item: "", loan: nil)
//        let navController = UINavigationController(rootViewController: controller)
//        navigationController?.pushViewController(navController, animated: true)
        
        let alert = showAlt(title: "Lorem ipsum".localized, message: "Lorem ipsum dolor sit amet".localized, style: .alert)
        let okAction = UIAlertAction(title: "Check Credit", style: .default) {_ in
            self.navigates(to: .checkCredit(.form(nil)))
        }
        alert.addAction(okAction)
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
