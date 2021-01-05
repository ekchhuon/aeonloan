//
//  Double + Extension.swift
//  AEON Loan
//
//  Created by aeon on 10/26/20.
//

import Foundation

extension Double{
    func expo(_ power: Double) -> Double {
        return pow(Double(self),Double(power))
    }
    
    var percent: Double {
        return self/100.0
    }

    
    /// rounding of 3 decimal place (ex. 5.123)
    func format(for currency: Currency) -> String  {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0 //currency == .khr ? 0:2
        formatter.roundingMode = .down
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = .us //currency == .khr ? .kh : .us
        guard let formated = formatter.string(from: NSNumber(value: self)) else {
            debugPrint("Unable to round/format double")
            return ""
        }
        return formated
    }
    
    
}

extension Locale {
    static let us = Locale(identifier: "en_US")
    static let kh = Locale(identifier: "km")
}
