//
//  Variable.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import Foundation

// MARK: - Variable
struct Variable: Codable {
    let header: Header?
    let body: Body
    
    // MARK: - Body
    struct Body: Codable {
        let success: Bool
        let message: String
        let code: Int
        let pagination: Pagination?
        let data: [Data]
    }
    
    // MARK: - Data
    struct Data: Codable {
        let id : String
        let titleEn, titleKh: String?
    }
    
    struct Pagination: Codable {
        let offset, limit, entries: Int
        let pages: [String]
    }
}

