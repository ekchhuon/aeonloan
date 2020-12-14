//
//  Login.swift
//  AEON Loan
//
//  Created by aeon on 12/14/20.
//

import Foundation

// MARK: - Login
struct Login: Codable {
    let accessToken, tokenType, refreshToken: String
    let expiresIn: Int
    let scope: String
    let error: String?
    let errorDescription: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope
        case error
        case errorDescription = "error_description"
    }
}
