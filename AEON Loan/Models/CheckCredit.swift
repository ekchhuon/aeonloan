//
//  CheckCredit.swift
//  AEON Loan
//
//  Created by aeon on 12/29/20.
//

import Foundation

// MARK: - CheckCredit
struct CheckCredit: Codable {
    let header: Header?
    let body: Body
    
    // MARK: - Body
    struct Body: Codable {
        let success: Bool
        let message: String
        let code: Int
        let data: Data?
    }
    
    // MARK: - DataClass
    struct Data: Codable {
        let score, decision: String
        let remark: String?
        let productOffer: [ProductOffer]
    }
    
    // MARK: - ProductOffer
    struct ProductOffer: Codable {
        let id: String
        let product: String?
        let fa: Int
    }
}




