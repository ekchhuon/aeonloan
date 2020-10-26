//
//  Calculator.swift
//  AEON Loan
//
//  Created by aeon on 10/26/20.
//

import Foundation

class Calculator {
    enum ServiceType {
        case repayment(CalculationType)
        case loanLimit(CalculationType)
    }

    enum CalculationType {
        case flatRate
        case effectiveRate
    }
    var amount: Double = 0
    var rate: Double = 0
    var term: Double = 0
    
    func calculate(_ serviceType: ServiceType) -> Double {
        switch serviceType {
        case .repayment(.flatRate):
            return repaymentFlatRate(amount: amount, rate: rate, term: term)
        case .repayment(.effectiveRate):
            return repaymentEffectiveRate(amount: amount, rate: rate, term: term)
        default:
            debugPrint("Incorrect Calculation")
            return 0
        }
    }
}

extension Calculator {
    //MARK: - Formular
    
    private func repaymentFlatRate(amount: Double, rate: Double, term: Double) -> Double {
        return amount * (((rate.percent * term) + 1)/term)
    }
    
    private func repaymentEffectiveRate(amount: Double, rate: Double, term: Double) -> Double {
        return amount * ( rate.percent / (1 - (1 + rate.percent).expo(-term)))
    }
}
