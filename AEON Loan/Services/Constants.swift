//
//  Constants.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Foundation
import Alamofire

enum Constant {

}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json
    case basic
    case bearer
    
    var value: String {
        switch self {
        case .json:
            return "application/json"
        case .basic:
            let clientID = "aeonLoanApp"
            let clientSecret = "Aeon@123!KH"
            let client = ("\(clientID):\(clientSecret)").asData
            let base64LoginString = client.base64EncodedString()
            print("Basic \(base64LoginString)")
            
            return "Basic \(base64LoginString)"
        case .bearer:
            return "Bearer \(Preference.accessToken)"
        }
    }
}

enum RequestParams {
    case body(_:Parameters)
    case url(_:Parameters)
    case multipart(_:UIImage)
    case bearer(_: Parameters)
}

