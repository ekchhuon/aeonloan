//
//  Province.swift
//  AEON Loan
//
//  Created by aeon on 12/15/20.
//

import Foundation

struct Location: Codable {
    let header: Header?
    let body: Body
    let error: String?
    let errorDescription: String?
    
    
    enum CodingKeys: String, CodingKey {
        case header
        case body
        case error
        case errorDescription = "error_description"
    }
     
    // MARK: - Body
    struct Body: Codable {
        let success: Bool
        let message: String
        let code: Int
        let pagination: Pagination?
        let data: [Data]
    }

    // MARK: - Datum
    struct Data: Codable {
        let name, code: String
    }
    
    struct Pagination: Codable {
        let offset, limit, entries: Int
        let pages: [String]
    }
}
