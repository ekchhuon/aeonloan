//
//  ScanInstructionViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/12/20.
//

import UIKit

extension SelfieInstructionViewController {
    static func instantiate(with data: UserAsset) -> SelfieInstructionViewController {
        let controller = SelfieInstructionViewController()
        controller.asset = data
        return controller
    }
}

class SelfieInstructionViewController: UIViewController {
    private var asset = UserAsset()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }



    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        navigates(to: .register(.selfie(asset)))
    }
}
