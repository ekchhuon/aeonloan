//
//  AuthController.swift
//  AEON Loan
//
//  Created by aeon on 12/15/20.
//

import Foundation

final class AuthController {
    
    static let serviceName = "AeonRohasService"
    
    static var isSignedIn: Bool {
        let currentUser = Preference.user
        do {
            let password = try KeychainPasswordItem(service: serviceName, account: currentUser.fullName).readPassword()
            return password.count > 0
        } catch {
            return false
        }
    }
    
    static var sha256: String {
        let key = "sha256"
        do {
            let sha256 = try KeychainPasswordItem(service: serviceName, account: key).readPassword()
            return sha256
        } catch {
            return ""
        }
    }
    
    class func saveSHA(_ sha256: String) throws {
        let key = "sha256"
        try KeychainPasswordItem(service: serviceName, account: key).savePassword(sha256)
    }
    
    class func signIn(_ user: User, password: String) throws {
        try KeychainPasswordItem(service: serviceName, account: user.fullName).savePassword(user.password.encrypt())
        Preference.user = user
    }
    
    class func signOut() throws {
        let currentUser = Preference.user
        try KeychainPasswordItem(service: serviceName, account: currentUser.email).deleteItem()
        Preference.clear(forKey: .user)
    }
}
