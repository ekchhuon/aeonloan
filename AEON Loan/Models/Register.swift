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
    let data: String
    
    // MARK: - DataClass
    struct Data: Codable {
        let code, timeout: Int
    }
}

struct RegisterError: Codable {
    let timestamp: String?
    let status: Int?
    let error: String?
    let path: String?
    let success: Bool?
    let message: String?
    let code: Int?
    let data: String?
    
    // MARK: - DataClass
    struct Data: Codable {
        let code, timeout: Int
    }
}
