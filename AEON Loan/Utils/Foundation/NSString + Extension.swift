//
//  NSString + Extension.swift
//  AEON Loan
//
//  Created by aeon on 10/5/20.
//

import Foundation
import CryptoKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // string to date
    func formatDate() -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        guard let formatted =  dateFormater.date(from: self) else {
            debugPrint("Unable to format date")
            return Date()
        }
        return formatted
    }
    
    // age from birthdate
    var asAge:Int {
        let birthday = self.formatDate()
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let components = calendar.components(.year, from: birthday, to: Date(), options: [])
        return components.year!
    }
    
    var asSha256: String {
        let hash = SHA256.hash(data: self.asData)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func random(length: Int = 5) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

/*
// MARK - Keychain
extension String {
    func getStoredPassword() -> String {
      let kcw = KeychainWrapper()
      if let password = try? kcw.getGenericPasswordFor(
        account: "RWQuickNote",
        service: "unlockPassword") {
        return password
      }

      return ""
    }

    func updateStoredPassword(_ password: String) {
      let kcw = KeychainWrapper()
      do {
        try kcw.storeGenericPasswordFor(
          account: "RWQuickNote",
          service: "unlockPassword",
          password: password)
      } catch let error as KeychainWrapperError {
        print("Exception setting password: \(error.message ?? "no message")")
      } catch {
        print("An error occurred setting the password.")
      }
    }

    func validatePassword(_ password: String) -> Bool {
      let currentPassword = getStoredPassword()
      return password == currentPassword
    }

    func changePassword(currentPassword: String, newPassword: String) -> Bool {
      guard validatePassword(currentPassword) == true else { return false }
      updateStoredPassword(newPassword)
      return true
    }
}
*/
