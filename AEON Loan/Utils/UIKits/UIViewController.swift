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
        case let .checkCredit(.form(loan)):
            let controller = CheckCreditFormViewController.instantiate(item: "", loan: loan)
            navigationController?.pushViewController(controller, animated: true)
        case let .checkCredit(.location(aplicant, loan)):
            let controller = LocationViewController.instantiate(data: aplicant, loan: loan)
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
        case let .register(.selfie(data)):
            let controller = SelfieViewController.instantiate(with: data)
            navigationController?.pushViewController(controller, animated: true)
        case let .register(.form(data)):
            /*
            let register = RegisterViewController.instantiate()
             // navigationController?.pushViewController(register, animated: true)
            
            self.view.window?.setRootViewController(register, options: .init(type: .push(subtype: .fromRight)))
            */
            
            let controller = RegisterViewController.instantiate(with: data)
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
        case let .OTP(user):
            let controller = OTPViewController.instantiate(user: user)
            navigationController?.pushViewController(controller, animated: true)
        default:
            debugPrint("Scene Not Found!")
        }
    }
}

// MARK: alert
extension UIViewController {
    //simple alert with optional completion
    func showAlert(title: String = "", message: String, buttonTitle: String = "OK".localized, okAction: (() -> Void)?  = nil) {
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
    func showAlt(title: String, message: String, actionTitle: String = "OK".localized, style: UIAlertController.Style, actionStyle: UIAlertAction.Style = .default, action: (() -> Void)?  = nil) -> UIAlertController {
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
        
//        let dismiss = UIAlertAction(title: dismissTitle.localized, style: .cancel, handler: nil)
        
        let defaultAction = UIAlertAction(title: actionTitle.localized, style: actionStyle) { _ in
            action?()
        }
        
        alert.addAction(defaultAction)
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
