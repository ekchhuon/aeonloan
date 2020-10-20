//
//  LoanSubmissionResultViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension LoanSubmissionResultViewController {
    static func instantiate(result: SubmitResult) -> LoanSubmissionResultViewController {
        let controller = LoanSubmissionResultViewController()
        controller.result = result
        return controller
    }
}
class LoanSubmissionResultViewController: UIViewController {
    @IBOutlet weak var successTitleLabel: UILabel!
    @IBOutlet weak var successSubtitleLabel: UILabel!
    @IBOutlet weak var checkCreditTitleLabel: UILabel!
    @IBOutlet weak var checkCreditButton: UIButton!
    
    var result: SubmitResult = .success
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard self.result == .success else {return}
            // self.navigates(to: .home(.push(subtype: .fromLeft)))
        }
    }
    
    private func setupView() {
        checkCreditButton.rounds(radius: 10, background: .white)
        successTitleLabel.isHidden = result == .failure
        successSubtitleLabel.isHidden = result == .failure
        checkCreditTitleLabel.isHidden = result == .success
        checkCreditButton.isHidden = result == .success
        
        switch result {
        case .success:
            successTitleLabel.text = NSLocalizedString("Thank!", comment: "")
            successSubtitleLabel.text = NSLocalizedString("We will contact you in 48 hours", comment: "")
        case .failure:
            checkCreditTitleLabel.text = NSLocalizedString("Please check your credit before apply loan", comment: "")
            checkCreditButton.setTitle(NSLocalizedString("Check Credit", comment: ""), for: .normal)
        }
        
    }
    
    @IBAction func checkCreditButtonTapped(_ sender: Any) {
        navigates(to: .checkCredit)
    }
}
