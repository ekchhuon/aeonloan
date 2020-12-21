//
//  Enum.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import Foundation
import UIKit

enum Scene {
    case home(CATransition.TransitionType)
    case language
    case notification
    case login
    case register(RegistrationScene)
    case slider(IndexPath, String)
    case checkCredit(CheckCreditScene)
    case applyLoan
    case loanResult(SubmitResult)
    case payment(PaymentScene)
    case calculator
    case OTP(with:User)
    //case scan
}

extension Scene {
    
    enum CheckCreditScene {
        // case takePhoto
        // case selfie
        case form
        case location
        case result(Result)
        enum Result {
            case accepted
            case rejected
        }
    }
    
    enum PaymentScene {
        case main
        case location
        case condition
        case schedule
        case scheduleDetailed(String)
    }
    
    enum RegistrationScene {
        case scanID
        case selfie
        case form
    }
    
    enum Loan {
        case loan
        case loanResult(SubmitResult)
    }
    
}

enum SubmitResult {
    case success
    case failure
}
