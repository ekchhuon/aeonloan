//
//  APIRouter.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Alamofire

//enum aa: URLRequestConvertible {
//    func asURLRequest() throws -> URLRequest {
//        <#code#>
//    }
//
//
//}

enum APIRouter: URLRequestConvertible {
    case rsa(param: Parameters)
    case aes(param: Parameters)
    case register2(param: Parameters)
    case getOTP(param: Parameters)
    case verifyOTP(param: Parameters)
    case login(Parameters)
    //case login(email:String, password:String)
    case register(param: Param.Register)
    //case testLogin(email: String, password: String)
    case articles
    case article(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .register, .rsa, .aes, .register2, .getOTP, .verifyOTP, .login:
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
        case .aes:
            return "aes"
        case .register2:
            return "user"
        case .getOTP:
            return "otp"
        case .verifyOTP:
            return "otp/verification"
        case .login:
            return "signin"
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
        case let .aes(param):
            return param
        case let .register2(param):
            return param
        case let .getOTP(param):
            return param
        case let .verifyOTP(param):
            return param
        case let .login(param):
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
        //        urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //        urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        if Preference.isLogin {
            var components = URLComponents()
            
            //            let login = Param.LoginData(username: "aeonrohas".encrypt(), password: "2020@Loan#Aeon4User".encrypt(), grant_type: "password", header: "\(json!)")
            //
            //
            components.queryItems = [URLQueryItem(name: "grant_type", value: "password"), URLQueryItem(name: "username", value: "aeonrohas".encrypt()), URLQueryItem(name: "password", value: "2020@Loan#Aeon4User".encrypt()), URLQueryItem(name: "header", value: Preference.header)]
            
//            components.query = components.query?.replacingOccurrences(of: "+", with: "%2B")
            
            print("Encrypted username:====","aeonrohas".encrypt())
            print("Encrypted username:====","aeonrohas".encrypt())
            
            urlRequest.httpBody = components.query?.data(using: .utf8)
            let comp = components.query?.asData
            print("components.query?.data(using: .utf8)", comp?.asString )
            
            urlRequest.setValue(ContentType.raw.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            urlRequest.setValue(ContentType.basic.value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            
            print("urlRequest", urlRequest)
            
        } else {
            urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
            urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        // Default timeout
        //urlRequest.timeoutInterval = 10
        
        // Parameters
        
        if !Preference.isLogin  {
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        }
        
        return urlRequest
    }
}

struct Param {
    struct Register: Codable {
        let username: String
        let phoneNumber: String
        let email: String
        let password: String
        let idPhoto: String
        let nidPassport: String
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
    
    // MARK: - Register
    struct MyRegister2: Codable {
        let header: Header
        let body: Body
    }
    
    // MARK: - Body
    struct Body: Codable {
        let encode: String
    }
    
    struct OTP: Codable {
        let code: String
    }
    
    struct LoginData: Codable {
        let username, password, grant_type: String
        let header: String
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

// MARK: - Register
struct AESResponse: Codable {
    let timestamp: Int
    let success: Bool
    let message: String
    let code: Int
    let data: String?
}

