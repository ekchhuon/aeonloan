//
//  BCrypt.swift
//  AEON Loan
//
//  Created by aeon on 10/8/20.
//

import Foundation
import BCryptSwift

// encryption
extension String {
    var bcrypted: String {
        let salt = BCryptSwift.generateSaltWithNumberOfRounds(12)
        return BCryptSwift.hashPassword(self, withSalt: salt) ?? ""
    }
}
