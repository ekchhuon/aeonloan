//
//  PaymentScheduleViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension PaymentOptionViewController {
    static func instantiate() -> PaymentOptionViewController {
        return PaymentOptionViewController()
    }
}
class PaymentOptionViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonTitles = ["Payment Location", "Payment Conditions", "Payment Schedule"]
        buttons.forEach { $0.rounds(radius: 10, background: .brandPurple ) }
        for (index, button) in buttons.enumerated() {
            button.setTitle(NSLocalizedString(buttonTitles[index], comment: ""), for: .normal)
        }
        


    }

    @IBAction func locationButtonTapped(_ sender: Any) {
        navigates(to: .paymentLocation)
    }
    
    @IBAction func conditionButtonTapped(_ sender: Any) {
        navigates(to: .paymentCondition)
    }

    @IBAction func ScheduleButtonTapped(_ sender: Any) {
        navigates(to: .paymentSchedule)
    }

}
