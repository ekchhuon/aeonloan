//
//  Enum.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import Foundation
import UIKit

enum SubmitResult {
    case success
    case failure
}

enum Scene {
    case home(CATransition.TransitionType)
    case language
    case notification
    case login
    case register
    case slider(IndexPath, String)
    case checkCredit
    case selfie
    case applicantInfo
    case creditAccepted
    case creditRejected(SubmitResult)
    case applyLoan
    case loanResult(SubmitResult)
    case payment
    case paymentLocation
    case paymentCondition
    case paymentSchedule
    case paymentScheduleDetail(String)
}

enum Loan {
    case loan
    case loanResult(SubmitResult)
}
