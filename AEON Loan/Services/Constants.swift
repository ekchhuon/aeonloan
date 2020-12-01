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
    case json = "application/json"
}
