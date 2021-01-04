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
        //let key = Preference.sha256 // "e9a9483dec41aebc5ae7da7257d195d8" //key: shar // data: json
        
        guard AuthController.sha256 != "" else {
            debugPrint("Encryption key invalid"); return ""
        }
        let key = AuthController.sha256
        let encrypted = RNCryptor.encrypt(data: self.asData, withPassword: key)
        return encrypted.base64Encoded
    }
    
    func decrypt() -> String {
        let key = AuthController.sha256
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


//extension String {
//    func aaa() {
//        let publicKey = try! PublicKey
//        let clear = try! ClearMessage(string: "Clear Text", using: .utf8)
//        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
//    }
//}


struct RSA {

static func encrypt(string: String, publicKey: String?) -> String? {
    guard let publicKey = publicKey else { return nil }

    let keyString = publicKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
    guard let data = Data(base64Encoded: keyString) else { return nil }

    var attributes: CFDictionary {
        return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits   : 2048,
                kSecReturnPersistentRef : true] as CFDictionary
    }

    var error: Unmanaged<CFError>? = nil
    guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
        print(error.debugDescription)
        return nil
    }
    return encrypt(string: string, publicKey: secKey)
}

static func encrypt(string: String, publicKey: SecKey) -> String? {
    let buffer = [UInt8](string.utf8)

    var keySize   = SecKeyGetBlockSize(publicKey)
    var keyBuffer = [UInt8](repeating: 0, count: keySize)

    // Encrypto  should less than key length
    guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
    return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
   }
}
