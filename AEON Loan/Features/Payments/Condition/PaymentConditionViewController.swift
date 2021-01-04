//
//  PaymentConditionViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension PaymentConditionViewController {
    static func instantiate() -> PaymentConditionViewController {
        return PaymentConditionViewController()
    }
}

class PaymentConditionViewController: BaseViewController {
    private let viewModel = PaymentConditionViewModel()
    @IBOutlet weak var conditionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Payment Condition".localized)
        
        viewModel.condition.bind { [weak self] (condition) in
            guard let self = self else { return }
            self.conditionTextView.text = condition
        }
    }
}
