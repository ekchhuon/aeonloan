//
//  ApplicationMessageViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

extension CreditRejectedViewController {
    static func instantiate(result: SubmitResult) -> CreditRejectedViewController {
        let controller = CreditRejectedViewController()
        controller.result = result
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
        setupLabel(with: "Thanks!", "Result will be ready to show soon.")
        validateResult()
    }
    
    private func validateResult() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            switch self.result {
            case .success:
                self.navigateToAccepted()
            case .failure:
                self.setupLabel(with: "Rejected", "We are so sorry. You dont meet our criteria. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,")
            }
        }
    }
    
    private func navigateToAccepted() {
        navigates(to: .creditAccepted)
    }
    
    private func setupLabel(with title: String, _ subtitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    func navigateToApplicationResult() {
        
    }
}
