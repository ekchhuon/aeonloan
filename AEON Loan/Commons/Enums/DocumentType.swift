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
    
    var identifier: String {
        switch self {
        case .nId(.khmer):
            return "Khmer Identity Card"
        case .nId(.foreigner):
            return "xxx identity Card"
        case .passport(.khmer):
            return "Cambodia Passport"
        case .passport(.foreigner):
            return "xxx Passport"
        default:
            return "Unknown Document"
        }
    }
    
    enum Nationality {
        case khmer
        case foreigner
    }
}
