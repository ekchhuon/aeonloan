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
    case loanSuccess
    case payment(PaymentScene)
    case calculator
    case OTP(with:User)
    //case scan
}

extension Scene {
    
    enum CheckCreditScene {
        // case takePhoto
        // case selfie
        case form(ApplyLoan?)
        case location(Applicant, ApplyLoan?)
        case result(Result)
        case results(CheckCredit?)
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
        case selfie(_ data: UserAsset)
        case form(_ data: UserAsset)
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
