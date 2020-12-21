//
//  AuthController.swift
//  AEON Loan
//
//  Created by aeon on 12/15/20.
//

import Foundation
import CryptoSwift

final class AuthController {
  
  static let serviceName = "AeonRohasService"
  
  static var isSignedIn: Bool {
    let currentUser = Preference.user
    do {
        let password = try KeychainPasswordItem(service: serviceName, account: currentUser.username).readPassword()
      return password.count > 0
    } catch {
      return false
    }
  }
  
  class func signIn(_ user: User, password: String) throws {
    try KeychainPasswordItem(service: serviceName, account: user.username).savePassword(password.encrypt())
    Preference.user = user
  }
  
  class func signOut() throws {
    let currentUser = Preference.user
    try KeychainPasswordItem(service: serviceName, account: currentUser.email).deleteItem()
    Preference.clear(forKey: .user)
  }
}
