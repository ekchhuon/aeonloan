//
//  LoanSubmissionResultViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit


extension LoanSubmissionResultViewController {
    static func instantiate(isCheckCredit: Bool) -> LoanSubmissionResultViewController {
        let controller = LoanSubmissionResultViewController()
        controller.isCheckCredit = isCheckCredit
        return controller
    }
}
class LoanSubmissionResultViewController: UIViewController {
    @IBOutlet weak var thankLabel: UILabel!
    @IBOutlet weak var thankSubTitle: UILabel!
    @IBOutlet weak var checkCreditTitleLabel: UILabel!
    @IBOutlet weak var doneStackView: UIStackView!
    @IBOutlet weak var checkCreditStackView: UIStackView!
    @IBOutlet weak var checkCreditButton: UIButton!
    
    var isCheckCredit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isTranslucent = false
        
        setupView()
    }
    
    private func setupView() {
        checkCreditStackView.isHidden = !isCheckCredit
        doneStackView.isHidden = isCheckCredit
        checkCreditButton.rounds(radius: 10, background: .white)
        
        thankLabel.text = NSLocalizedString("Thank!", comment: "")
        thankSubTitle.text = NSLocalizedString("We will contact you in 48 hours", comment: "")
        checkCreditTitleLabel.text = NSLocalizedString("Please check your credit before apply loan", comment: "")
        checkCreditButton.setTitle(NSLocalizedString("Check Credit", comment: ""), for: .normal)
    }
    
    private func setupDoneStack() {
        
    }
    
    private func setupCheckCreditStack() {
        
    }
    
    
    @IBAction func checkCreditButtonTapped(_ sender: Any) {
    }
    
}
