//
//  Encryption.swift
//  AEON Loan
//
//  Created by aeon on 10/22/20.
//

import Foundation
import RNCryptor

extension String {
    func encrypt() -> String {
        let key = "e9a9483dec41aebc5ae7da7257d195d8"
        let encrypted = RNCryptor.encrypt(data: self.asData, withPassword: key)
        return encrypted.base64Encoded
    }
    
    func decrypt() -> String {
        let key = "e9a9483dec41aebc5ae7da7257d195d8"
        do {
            let decrypted = try RNCryptor.decrypt(data: self.base64Decoded, withPassword: key)
            return decrypted.asString
        } catch {
            print(error)
            return ""
        }
    }
}
