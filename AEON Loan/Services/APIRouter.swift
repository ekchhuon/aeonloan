//
//  APIRouter.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case rsa(param: Parameters)
    //case login(email:String, password:String)
    case register(param: Param.Register)
    //case testLogin(email: String, password: String)
    case articles
    case article(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .register, .rsa:
            return .post
        case .articles, .article:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .rsa:
            return "rsa"
//        case .login:
//            return "login"
        case .register:
            return "users"
//        case .testLogin:
//            return "login"
        case .articles:
            return "articles/all.json"
        case .article(let id):
            return "article/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case let .rsa(param):
            return param
//        case .login(let email, let password):
//            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .register(let param):
            return ["username": param.username, "phoneNumber":"012345678", "email": param.email, "password": param.password.bcrypted]
//        case .testLogin(let email, let password):
//            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .articles, .article:
            return nil
            
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constantss.server.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Default timeout
        urlRequest.timeoutInterval = 10
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

struct Param {
    struct Register: Codable {
        let username: String
        let phone: String
        let email: String
        let password: String
    }
    
    // MARK: - Register
    struct MyRegister: Codable {
        let header: Header
        let body: String
    }

    // MARK: - Header
    struct Header: Codable {
        let timestamp, encode, lan, channel: String
        let ipAddress, userID, appID, appVersion: String
        let deviceBrand, deviceModel, devicePlanform, deviceID: String
        let osVersion: String

        enum CodingKeys: String, CodingKey {
            case timestamp, encode, lan, channel, ipAddress
            case userID = "userId"
            case appID = "appId"
            case appVersion, deviceBrand, deviceModel, devicePlanform
            case deviceID = "deviceId"
            case osVersion
        }
    }
}


// MARK: - Register
struct RegisterResponse: Codable {
    let timestamp: Int
    let success: Bool
    let message: String
    let code: Int
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let publicKey: String
}
