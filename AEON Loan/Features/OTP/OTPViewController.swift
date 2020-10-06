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

class OTPViewController: BaseViewController, UITextFieldDelegate {
    private let viewModel = OTPViewModel()
    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields.forEach {
            $0.setBorder(5, border: .white, width: 1)
            $0.delegate = self
            $0.textContentType = .oneTimeCode
            $0.keyboardType = .numberPad
            $0.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        }
        
        textFields[0].becomeFirstResponder()
    }
    
    func validOTP(value: String) {
        showAlert(message: "Valid \(value)")
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        let first = textFields[0], second = textFields[1], third = textFields[2], fourth = textFields[3]

        if  text?.count == 1 {
            switch textField{
            case first:
                second.becomeFirstResponder()
            case second:
                third.becomeFirstResponder()
            case third:
                fourth.becomeFirstResponder()
            case fourth:
                fourth.resignFirstResponder()
            default:
                break
            }
        }
        
        if text?.count == 0 {
            switch textField{
            case first:
                first.becomeFirstResponder()
            case second:
                first.becomeFirstResponder()
            case third:
                second.becomeFirstResponder()
            case fourth:
                third.becomeFirstResponder()
            default:
                break
            }
        } else{}
        
        let values = [first.text!, second.text!, third.text!, fourth.text! ].filter { $0 != "" }
        if values.count == 4 {
            let value = values.joined(separator: "")
            validOTP(value: value)
        }
        
    }
}
