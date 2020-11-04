//
//  ApplicationMessageViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

extension CreditRejectedViewController {
    static func instantiate() -> CreditRejectedViewController {
        let controller = CreditRejectedViewController()
        // controller.result = result
        return controller
    }
}

class CreditRejectedViewController: BaseViewController {
    private let viewModel = CreditRejectedViewModel()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var result: SubmitResult = .success
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.setupLabel(with: "Rejected", "We are so sorry. You dont meet our criteria. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
    }
    
    private func navigateToAccepted() {
        navigates(to: .checkCredit(.result(.accepted)))
    }
    
    private func setupLabel(with title: String, _ subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
}
