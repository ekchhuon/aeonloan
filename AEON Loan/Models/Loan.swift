//
//  Loan.swift
//  AEON Loan
//
//  Created by aeon on 1/5/21.
//

import Foundation

// MARK: - Loan
struct Loan: Codable {
    let header: Header?
    let body: Body
    
    // MARK: - Body
    struct Body: Codable {
        let success: Bool
        let message: String
        let code: Int
        let data: String?
    }
}


