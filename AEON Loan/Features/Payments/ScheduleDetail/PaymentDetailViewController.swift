//
//  PaymentDetailViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension PaymentDetailViewController {
    static func instantiate(item: String) -> PaymentDetailViewController {
        let controller = PaymentDetailViewController()
        controller.agreement = item
        return controller
    }
}

class PaymentDetailViewController: BaseViewController {
    private let viewModel = PaymentDetailViewModel()
    @IBOutlet weak var agreementNumber: UILabel!
    var agreement = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(title: NSLocalizedString("Payment Details", comment: ""))
        self.agreementNumber.text = agreement
    }
    
}
