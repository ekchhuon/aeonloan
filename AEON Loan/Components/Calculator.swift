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
    var income: Double = 0
    var otherLoan: Double = 0
    var amount: Double = 0
    var rate: Double = 0
    var term: Double = 0
    var housing: Housing = .owned
    
    func calculate(_ serviceType: ServiceType) -> Double {
        switch serviceType {
        case .repayment(.flatRate):
            return repaymentFlatRate()
        case .repayment(.effectiveRate):
            return repaymentEffectiveRate()
        case .loanLimit(.flatRate):
            return loanLimitFlatRate()
        case .loanLimit(.effectiveRate):
            return loandLimitEffectiveRate()
        }
    }
    
    func value() {
        print("value:", income, otherLoan, amount, rate.percent, term, housing.rate)
    }
}

extension Calculator {
    //MARK: - Formular
    
    private func repaymentFlatRate() -> Double {
        return amount * (((rate.percent * term) + 1)/term)
    }
    
    private func repaymentEffectiveRate() -> Double {
        return amount * ( rate.percent / (1 - (1 + rate.percent).expo(-term)))
    }
    
    private func loanLimitFlatRate() -> Double {
        return term * ((income * housing.rate) - otherLoan) / ((rate.percent * term) + 1)
    }
    
    private func loandLimitEffectiveRate() -> Double {
        return (((income * housing.rate) - otherLoan) * (1 - (1+rate.percent).expo(-term)))/rate.percent
    }
}
