//
//  Constants.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

//import Foundation
//import Alamofire
//
//struct Constants {
//    struct ProductionServer {
//        static let baseURL = "https://api.jsonapi.co/rest/v1/user" //"https://www.apiserver.com"
//    }
//}
//
//enum HTTPHeaderField: String {
//    case authentication = "Authorization"
//    case contentType = "Content-Type"
//    case acceptType = "Accept"
//    case acceptEncoding = "Accept-Encoding"
//    case string = "String"
//
//}
//
//enum ContentType: String {
//    case json = "Application/json"
//    case formEncode = "application/x-www-form-urlencoded"
//}
//
//enum RequestParams {
//    case body(_:Parameters)
//    case url(_:Parameters)
//}

import Foundation


enum ConstantEnum {
    enum UserAttributes: String {
        case name
        case email
        case address
        case position = "custom:position"
        case organization = "custom:organization"
        case picture
        case phone = "phone_number"
        case topics = "custom:topics"
    }
}

//struct Constants {
//    struct ProductionServer {
////        static let baseURL = "https://api.jsonapi.co/rest/v1/user" //"http://itechnodev.com/api"
//        static let baseURL = "http://192.168.169.13:8182/webservice"
//    }
//
//    struct APIParameterKey {
//        static let password = "password"
//        static let email = "email"
//
//
//    }
//}

enum Constantss {
//    enum UserAttributes: String {
//        case name
//        case email
//        case address
//        case position = "custom:position"
//        case organization = "custom:organization"
//        case picture
//        case phone = "phone_number"
//        case topics = "custom:topics"
//    }
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
    case raw
    
    var value: String {
        switch self {
        case .json:
            return "application/json"
        case .basic:
            let username = Preference.loginUser.username  //"username"
            let password = Preference.loginUser.password
            let loginData = "\(username):\(password)".asData
            let base64LoginString = loginData.base64EncodedString()
            
            print("Basic \(base64LoginString)")
            
            return "Basic \(base64LoginString)"
        case .raw:
            return "application/x-www-form-urlencoded"
        }
    }
}



//import Foundation
//import Alamofire
//
//enum APIRouters: APIConfiguration {
//
//    case login(username:String, password:String)
//    case getUserDetails
//
//
//    // MARK: - HTTPMethod
//    var method: HTTPMethod {
//        switch self {
//        case .login:
//            return .post
//        case .getUserDetails:
//            return .get
//        }
//    }
//    // MARK: - Parameters
//     var parameters: RequestParams {
//        switch self {
//        case .login(let username, let password):
//            return .body(["username":username,"password":password])
//        case .getUserDetails:
//            return.body([:])
//        }
//    }
//
//    // MARK: - Path
//    var path: String {
//        switch self {
//        case .login:
//            return "/loginEndpoint"
//        case .getUserDetails:
//            return "/userDetailEndpoint"
//        }
//    }
//
//    // MARK: - URLRequestConvertible
//    func asURLRequest() throws -> URLRequest {
//        let url = try Constants.ProductionServer.baseURL.asURL()
//
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
//
//        // HTTP Method
//        urlRequest.httpMethod = method.rawValue
//
//        // Common Headers
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
//        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
//
//        // Parameters
//        switch parameters {
//
//        case .body(let params):
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//
//        case .url(let params):
//                let queryParams = params.map { pair  in
//                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
//                }
//                var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
//                components?.queryItems = queryParams
//                urlRequest.url = components?.url
//        }
//            return urlRequest
//    }
//}
