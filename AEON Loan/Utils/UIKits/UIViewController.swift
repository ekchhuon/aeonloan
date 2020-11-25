//
//  UIViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/23/20.
//

import Foundation
import UIKit

// MARK: Navigation Scenes
extension UIViewController {
    func navigates(to scene: Scene) {
        switch scene {
        case let .loanResult(result):
            let controller = LoanSubmissionResultViewController.instantiate(result: result)
            navigationController?.pushViewController(controller, animated: true)
//        case .checkCredit(.takePhoto):
//            // let controller = TakePhotoViewController.instantiate()
//            let controller = PhotoViewController.instantiate()
//            navigationController?.pushViewController(controller, animated: true)
//        case .scan:
//            let controller = ScanViewController.instantiate()
//            navigationController?.pushViewController(controller, animated: true)
//        case .checkCredit(.selfie):
//            let controller = SelfieViewController.instantiate()
//            navigationController?.pushViewController(controller, animated: true)
        case .checkCredit(.form):
            let controller = ApplicantInfoViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .checkCredit(.result(.accepted)):
            let controller = CreditAcceptedViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .checkCredit(.result(.rejected)):
            let controller = CreditRejectedViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case let .home(transition):
            let home = HomeViewController.instantiate()
            let controller = NavigationController.main(with: home)
            self.view.window?.setRootViewController(controller, options: .init(type: transition))
        case .language:
            let selectLanguage = SelectLanguageViewController.instantiate()
            view.window?.setRootViewController(selectLanguage)
        case .login:
            
            /*
            let login = LoginViewController.instantiate()
            // let controller = NavigationController.main(with: home)
            self.view.window?.setRootViewController(home, options: .init(type: .push(subtype: .fromRight)))
            */
             let controller = LoginViewController.instantiate()
             navigationController?.pushViewController(controller, animated: true)
        case .register(.scanID):
            let controller = ScanViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .register(.selfie):
            let controller = SelfieViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .register(.fillingForm):
            /*
            let register = RegisterViewController.instantiate()
             // navigationController?.pushViewController(register, animated: true)
            
            self.view.window?.setRootViewController(register, options: .init(type: .push(subtype: .fromRight)))
            */
            
            let controller = RegisterViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .notification:
            let notification = NotificationViewController.instantiate()
            navigationController?.pushViewController(notification, animated: true)
        case let .slider(index, item):
            let detailed = SliderDetailViewController.instantiate(index: index, item: item)
            navigationController?.pushViewController(detailed, animated: true)
        case .applyLoan:
            let detailed = ApplyLoanViewController.instantiate()
            navigationController?.pushViewController(detailed, animated: true)
        case .payment(.main):
            let controller = PaymentOptionViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .payment(.location):
            let controller = PaymentLocationViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .payment(.condition):
            let controller = PaymentConditionViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .payment(.schedule):
            let controller = PaymentScheduleViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case let .payment(.scheduleDetailed(data)):
            let controller = PaymentDetailViewController.instantiate(item: data)
            navigationController?.pushViewController(controller, animated: true)
        case .calculator:
            let controller = CalculatorViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .OTP:
            let controller = OTPViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        default:
            debugPrint("Scene Not Found!")
        }
    }
}

// MARK: alert
extension UIViewController {
    //simple alert with optional completion
    func showAlert(title: String = "OK", message: String, buttonTitle: String = "OK", okAction: (() -> Void)?  = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            okAction?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //alert with title completion & style. 
    func showALertWithOption(title: String, message: String, dismissButtonTitle: String, okButtonTitle: String, style: UIAlertController.Style = .alert, dismissActionStyle: UIAlertAction.Style = .default, okActionStyle: UIAlertAction.Style = .default, dismissAction:@escaping ()-> Void, okAction:@escaping ()-> Void) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: dismissActionStyle) { (action) in
            dismissAction()
        }
        let okAction = UIAlertAction(title: okButtonTitle, style: okActionStyle) { (action) in
            okAction()
        }
        alert.addAction(okAction)
        alert.addAction(dismissAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @discardableResult
    func showAlt(title: String, message: String, style: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .right
//        let messageText = NSAttributedString(
//            string: "message",
//            attributes: [
//                NSAttributedString.Key.paragraphStyle: paragraphStyle,
//                NSAttributedString.Key.foregroundColor : UIColor.brandPurple,
//                //NSAttributedString.Key.font : UIFont(name: "name", size: 17)
//            ]
//        )
        
        

//        alert.setValue(messageText, forKey: "attributedMessage")
        
        
        let dismiss = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        
        
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
        return alert
    }
    
}

extension UIViewController {
    // MARK: - Add child controller to another controller
    func add(child controller: UIViewController) {
        controller.willMove(toParent: self)
        self.view.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
    }
}
