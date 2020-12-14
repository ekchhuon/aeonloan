//
//  Response.swift
//  AEON Loan
//
//  Created by aeon on 12/12/20.
//

import Foundation

struct Response: Codable {
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
        let data: Data?
    }
    
    // MARK: - DataClass
    struct Data: Codable {
        let publicKey: String
    }
}
