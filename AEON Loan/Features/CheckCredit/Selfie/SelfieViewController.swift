//
//  SelfieViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import UIKit

extension SelfieViewController {
    static func instantiate() -> SelfieViewController {
        return SelfieViewController()
    }
}

class SelfieViewController: BaseViewController {
    private let viewModel = SelfieViewModel()
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.rounds(radius: 10, background: .brandPurple)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Next Tapped
    @IBAction func next(_ sender: Any) {
//        let controller = ApplicantInfoViewController.instantiate()
//        navigationController?.pushViewController(controller, animated: true)
        navigates(to: .checkCredit(.form))
    }
}
