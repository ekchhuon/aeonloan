//
//  DocumentType.swift
//  AEON Loan
//
//  Created by aeon on 11/11/20.
//

import Foundation
enum DocumentType: Equatable {
    case nId(Nationality)
    case passport(Nationality)
    case unknown
    
    var description: String {
        switch self {
        case .nId(.khmer):
            return "Khmer Identity Card"
        case .nId(.japanese):
            return "Japanese identity Card"
        case .passport(.khmer):
            return "Cambodia Passport"
        case .passport(.japanese):
            return "Japanese Passport"
        default:
            return "Unknown Document"
        }
    }
    
    var regex: String {
        switch self {
        case .nId(.khmer):
            return "^[0-9]{9}$" // 9 digit for Khmer ID:
        case .passport(.japanese):
            return "^[A-Za-z]{2}[0-9]{7}$" // 2Char + 7Digit, eg. TR6492357
        default:
            return ""
        }
    }
    
    enum Nationality {
        case khmer
        case japanese
    }
}
