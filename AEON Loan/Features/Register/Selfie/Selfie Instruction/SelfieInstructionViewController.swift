//
//  ScanInstructionViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/12/20.
//

import UIKit

extension SelfieInstructionViewController {
    static func instantiate() -> SelfieInstructionViewController {
        return SelfieInstructionViewController()
    }
}

class SelfieInstructionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        navigates(to: .register(.selfie))
    }
}
