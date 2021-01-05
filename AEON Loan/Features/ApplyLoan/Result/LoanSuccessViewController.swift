//
//  LoanSubmissionResultViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension LoanSuccessViewController {
    static func instantiate() -> LoanSuccessViewController {
        let controller = LoanSuccessViewController()
//        controller.result = result
        return controller
    }
}
class LoanSuccessViewController: UIViewController {
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeButton.rounds(radius: 10)
    }
        
    @IBAction func homeButtonTapped(_ sender: Any) {
//        navigates(to: .checkCredit(.form(nil)))
        navigates(to: .home(.moveIn(subtype: .fromLeft)))
    }
}
