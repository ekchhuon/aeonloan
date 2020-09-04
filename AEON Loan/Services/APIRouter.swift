//
//  APIRouter.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(email:String, password:String)
    case testLogin(email: String, password: String)
    case articles
    case article(id: Int)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .testLogin:
            return .post
        case .articles, .article:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/login"
        case .testLogin:
            return "/login"
        case .articles:
            return "/articles/all.json"
        case .article(let id):
            return "/article/\(id)"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .testLogin(let email, let password):
            return [Constants.APIParameterKey.email: email, Constants.APIParameterKey.password: password]
        case .articles, .article:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
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
