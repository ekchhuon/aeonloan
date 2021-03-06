//
//  APIError.swift
//  AEON Loan
//
//  Created by aeon on 12/11/20.
//

import Foundation
import Alamofire

struct APIError {
    let code: Int
    let description: String
    let localized: String
}

extension AFError {
    var evaluate: APIError {
        guard let code = self.responseCode else {
            debugPrint("Error", self.localizedDescription)
            return APIError(code: 0, description: "Unknown".localized, localized: self.errorDescription?.replace("URLSessionTask failed with error:", with: "") ?? "")
        }
        
        return APIError(code: code, description: code.description, localized: self.localizedDescription)
    }
}

extension String {
    func replace(_ occuring: String, with newString: String) -> String {
        return self.replacingOccurrences(of: occuring, with: newString)
    }
}
