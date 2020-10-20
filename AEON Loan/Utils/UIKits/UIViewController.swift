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
        case .checkCredit:
            let controller = TakePhotoViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .selfie:
            let controller = SelfieViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .applicantInfo:
            let controller = ApplicantInfoViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .creditAccepted:
            let controller = CreditAcceptedViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case let .creditRejected(result):
            let controller = CreditRejectedViewController.instantiate(result: result)
            navigationController?.pushViewController(controller, animated: true)
        case let .home(transition):
            let home = HomeViewController.instantiate()
            let controller = NavigationController.main(with: home)
            self.view.window?.setRootViewController(controller, options: .init(type: transition))
        case .language:
            let selectLanguage = SelectLanguageViewController.instantiate()
            view.window?.setRootViewController(selectLanguage)
        case .login:
            let login = LoginViewController.instantiate()
            navigationController?.pushViewController(login, animated: true)
        case .register:
            let register = RegisterViewController.instantiate()
            navigationController?.pushViewController(register, animated: true)
        case .notification:
            let notification = NotificationViewController.instantiate()
            navigationController?.pushViewController(notification, animated: true)
        case let .slider(index, item):
            let detailed = SliderDetailViewController.instantiate(index: index, item: item)
            navigationController?.pushViewController(detailed, animated: true)
        case .applyLoan:
            let detailed = ApplyLoanViewController.instantiate()
            navigationController?.pushViewController(detailed, animated: true)
        case .payment:
            let controller = PaymentOptionViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .calculator:
            let controller = CalculatorViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .paymentLocation:
            let controller = PaymentLocationViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .paymentCondition:
            let controller = PaymentConditionViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case .paymentSchedule:
            let controller = PaymentScheduleViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        case let .paymentScheduleDetail(data):
            let controller = PaymentDetailViewController.instantiate(item: data)
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
    func showALertWithTitleAndMessages(title: String, message: String, dismissButtonTitle: String, okButtonTitle: String, style: UIAlertController.Style = .alert, dismissAction:@escaping ()-> Void, okAction:@escaping ()-> Void) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: .default) { (action) in
            dismissAction()
        }
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { (action) in
            okAction()
        }
        alert.addAction(dismissAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
