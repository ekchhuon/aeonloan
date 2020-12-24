//
//  APIRouter.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Alamofire

enum UploadAPIRouter {
    case profile, document
    private var path: String {
        switch self {
        case .profile: return "public/v1/upload/profile"
        case .document: return "public/v1/upload/nid_passport"
        }
    }
    var url: URL? {
        return URL(string: Constant.server + path)
    }
}

enum APIRouter: URLRequestConvertible {
    case rsa(param: Parameters)
    case aes(param: Parameters)
    case register2(param: Parameters)
    case getOTP(param: Parameters)
    case verifyOTP(param: Parameters)
    case login(Parameters)
    case logout(Parameters)
    case upload(UIImage)
    //case login(email:String, password:String)
    case register(param: Param.Register)
    //case testLogin(email: String, password: String)
    case articles
    case article(id: Int)
//    case province(Parameters)
//    case district(Parameters)
//    case commune(Parameters)
//    case village(Parameters)
    case location(ParamLocation)
    case workingPeriod(Parameters)
    case livingPeriod(Parameters)
    case occupation(Parameters)
    case housingType(Parameters)
    case education(Parameters)
    case maritialStatus(Parameters)
    case gender(Parameters)
    case checkCredit(Parameters)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .register, .rsa, .aes, .register2, .getOTP, .verifyOTP, .login, .logout, .upload, .location, .occupation, .housingType, .education, .maritialStatus, .gender, .checkCredit, .workingPeriod, .livingPeriod:
            return .post
        case .articles, .article:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .rsa: return "public/v1/rsa"
        case .aes: return "public/v1/aes"
        case .register2: return "public/v1/user"
        case .getOTP: return "public/v1/otp"
        case .verifyOTP: return "public/v1/otp/verification"
        case .login: return "public/v1/signin"
        case .logout: return "private/v1/signout"
        case .upload: return "public/v1/upload/profile"
        //        case .login:
        //            return "login"
        case .register: return "public/v1/users"
        //        case .testLogin:
        //            return "login"
        case .articles: return "articles/all.json"
        case .article(let id): return "article/\(id)"
//        case .province: return "public/v1/province"
//        case .district: return "public/v1/commune"
//        case .commune: return "public/v1/commune"
//        case .village: return "public/v1/commune"
        case .location(.province): return "public/v1/province"
        case .location(.district): return "public/v1/district"
        case .location(.commune): return "public/v1/commune"
        case .location(.village): return "public/v1/village"
        case .education, .housingType, .occupation, .maritialStatus, .gender, .workingPeriod, .livingPeriod: return "public/v1/variable"
        case .checkCredit: return "private/v1/check_credit"
        }
    }
    
    
    // MARK: - Parameters
    private var parameters: RequestParams? {
        switch self {
        case let .rsa(param): return .body(param)
        case let .aes(param): return .body(param)
        case let .register2(param): return .body(param)
        case let .getOTP(param): return .body(param)
        case let .verifyOTP(param): return .body(param)
        case let .login(param): return .url(param)
        case let .logout(param): return .bearer(param)
        case let .upload(image):
            return .multipart(image)
        //        case .login(let email, let password):
        //            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .register(let param):
            return .body(["username": param.username, "phoneNumber":"012345678", "email": param.email, "password": param.password])
        //        case .testLogin(let email, let password):
        //            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .articles, .article:
            return nil
        case let .location(.province(param)): return .body(param)
        case let .location(.district(param)): return .body(param)
        case let .location(.commune(param)): return .body(param)
        case let .location(.village(param)): return .body(param)
        case let .occupation(param), let .gender(param), let .maritialStatus(param), let .education(param), let .housingType(param), let .workingPeriod(param), let .livingPeriod(param): return .body(param)
        case let .checkCredit(param): return .body(param)
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constant.server.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        //        urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //        urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        
        /*
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
        
        */
        
        
        
        // Headers
        urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch parameters {
        case .url:
            urlRequest.setValue(ContentType.basic.value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        case .body, .multipart:
            urlRequest.setValue(ContentType.json.value, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        case .bearer:
            urlRequest.setValue(ContentType.bearer.value, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        default : break
        }
        
        
        
        // Default timeout
        //urlRequest.timeoutInterval = 10
        
        // Parameters
        
        switch parameters {
        case let .body(params), let .bearer(params):
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
            /*
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
            */
        case let .url(params):
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            /*
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
            //components?.queryItems = queryParams
            
            components?.queryItems = [URLQueryItem(name: "grant_type", value: "password"), URLQueryItem(name: "username", value: "aeonrohas".encrypt()), URLQueryItem(name: "password", value: "2020@Loan#Aeon4User".encrypt()), URLQueryItem(name: "header", value: Preference.header)]
            
            urlRequest.httpBody = components?.query?.data(using: .utf8)
            
            //urlRequest.url = components?.url
        
        */
        case let .multipart(image):
            print("image", image)
        default:
            print("This is multipart")
        }
        /*
        if !Preference.isLogin  {
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        }
        */
        return urlRequest
    }
}



