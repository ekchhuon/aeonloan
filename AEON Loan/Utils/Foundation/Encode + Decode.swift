//
//  Encode + Decode.swift
//  AEON Loan
//
//  Created by aeon on 10/22/20.
//

import Foundation

extension Data{
    // Data to string as utf8
    var asString: String {
        return String(decoding: self, as: UTF8.self)
    }
    
    // Base64 encode | Base-64 encoded string
    var base64Encoded: String {
        return self.base64EncodedString()
    }
}

extension String {
    // Base64 decode | strings to data as Base-64
    var base64Decoded: Data {
        guard let base64 = Data(base64Encoded: self) else {
            debugPrint("Unable to decode", self)
            return Data()
        }
        return base64
    }
    // strings to data as utf8
    var asData: Data {
        return Data(self.utf8)        
    }
}

// endcode to & from base64
extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
