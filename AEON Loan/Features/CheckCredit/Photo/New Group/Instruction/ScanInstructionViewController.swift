//
//  ScanInstructionViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/12/20.
//

import UIKit

extension ScanInstructionViewController {
    static func instantiate() -> ScanInstructionViewController {
        return ScanInstructionViewController()
    }
}

class ScanInstructionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        navigates(to: .checkCredit(.selfie))
    }
}
