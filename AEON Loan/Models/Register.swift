//
//  Register.swift
//  AEON Loan
//
//  Created by aeon on 10/6/20.
//

import Foundation
// MARK: - Register
struct Register: Codable {
    let timestamp: Int64
    let success: Bool
    let message: String
    let code: Int
    let data: Data?
    
    // MARK: - DataClass
    struct Data: Codable {
        let code, timeout: Int
    }
}
