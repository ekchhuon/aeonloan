//
//  Encryption.swift
//  AEON Loan
//
//  Created by aeon on 10/22/20.
//

import Foundation
import RNCryptor
import CryptoSwift
import SwiftyRSA

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

//extension String {
//    func aesEncrypt() throws -> String {
//        let encrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
//        return Data(encrypted).base64EncodedString()
//    }
//
//    func aesDecrypt() throws -> String {
//        guard let data = Data(base64Encoded: self) else { return "" }
//        let decrypted = try AES(key: KEY, iv: IV, padding: .pkcs7).decrypt([UInt8](data))
//        return String(bytes: decrypted, encoding: .utf8) ?? self
//    }
//}

enum Operation {
    case encrypt
    case decrypt
}


/*
 
 

 
 
 
 */


extension String {
    func aaa() {
        let publicKey = try! PublicKey
        let clear = try! ClearMessage(string: "Clear Text", using: .utf8)
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
    }
}
