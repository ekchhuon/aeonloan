//
//  OTPViewController.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import UIKit

extension OTPViewController {
    static func instantiate() -> OTPViewController {
        return OTPViewController()
    }
}

class OTPViewController: BaseViewController {
    private let viewModel = OTPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
