//
//  Currency.swift
//  AEON Loan
//
//  Created by aeon on 11/11/20.
//

import Foundation
enum Currency: String {
    case khr = "KHR"
    case usd = "USD"
    var index: Int {
        switch self {
        case .usd:
            return 0
        case .khr:
            return 1
        }
    }
    var symbol: String {
        return self.rawValue
    }
}
