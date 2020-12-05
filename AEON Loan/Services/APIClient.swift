//
//  APIClient.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Alamofire

class APIClient {
    @discardableResult
    private static func fetch<M:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<M, AFError>)->Void) -> DataRequest {
        Preference.isLogin = false
        return AF.request(route).validate().responseDecodable (decoder: decoder){ (response: DataResponse<M, AFError>) in
                            response.logs()
                            completion(response.result)
            print("response result:", response.response?.statusCode)
        }
    }
    
    private static func upload<M:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<M, AFError>)->Void) -> DataRequest {
        return AF.upload(multipartFormData: { (multipart) in
//            for (key, value)
        }, to: <#T##URLConvertible#>)
        }
    }
    
func uploadImage(isUser:Bool, endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((_ isSuccess:Bool) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){

    headerFile()
   
    AF.upload(multipartFormData: { multipartFormData in
        
        for (key, value) in parameters {
            if let temp = value as? String {
                multipartFormData.append(temp.data(using: .utf8)!, withName: key)
            }
            if let temp = value as? Int {
                multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
            }
            if let temp = value as? NSArray {
                temp.forEach({ element in
                    let keyObj = key + "[]"
                    if let string = element as? String {
                        multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                    } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                    }
                })
            }
        }
        
        if let data = imageData{
            multipartFormData.append(data, withName: "file", fileName: "\(Date.init().timeIntervalSince1970).png", mimeType: "image/png")
        }
    },
              to: endUrl, method: .post , headers: headers)
        .responseJSON(completionHandler: { (response) in
            
            print(response)
            
            if let err = response.error{
                print(err)
                onError?(err)
                return
            }
            print("Succesfully uploaded")
            
            let json = response.data
            
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                print(jsonObject)
            }
        })
  }
    
    
    private static func upload<M:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<M, AFError>)->Void) -> DataRequest {
        Preference.isLogin = false
        return AF.upload(multipartFormData: { (multipart) in
            <#code#>
        }, with: <#T##URLRequestConvertible#>)
        }
    }
    
//    static func login(email: String, password: String, completion:@escaping (Result<User, AFError>)->Void) {
//        fetch(route: APIRouter.login(email: email, password: password), completion: completion)
//    }
    
    static func getArticles(completion:@escaping (Result<[Article], AFError>)->Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.articleDateFormatter)
        fetch(route: APIRouter.articles, decoder: jsonDecoder, completion: completion)
    }
    
//    static func testLogin(email: String, password: String, completion:@escaping(Result<Login, AFError>)->Void) {
//        fetch(route: APIRouter.testLogin(email: email, password: password), completion: completion)
//    }
    
    static func register(with param: Param.Register, completion:@escaping(Result<Register, AFError>) -> Void) {
        fetch(route: APIRouter.register(param: param), completion: completion)
    }
    
    static func getRSA(param: Parameters, completion:@escaping(Result<RegisterResponse, AFError>) -> Void) {
        fetch(route: APIRouter.rsa(param: param), completion: completion)
    }
    
    static func submitEncryption(param: Parameters, completion:@escaping(Result<AESResponse, AFError>) -> Void) {
        fetch(route: APIRouter.aes(param: param), completion: completion)
    }
    
    static func register2(param: Parameters, completion:@escaping(Result<AESResponse, AFError>) -> Void ) {
        fetch(route: APIRouter.register2(param: param), completion: completion)
    }
    
    static func getOTP(param: Parameters, completion:@escaping(Result<OTP, AFError>) -> Void ) {
        fetch(route: APIRouter.getOTP(param: param), completion: completion)
    }
    
    static func verifyOTP(param: Parameters, completion:@escaping(Result<AESResponse, AFError>) -> Void ) {
        fetch(route: APIRouter.verifyOTP(param: param), completion: completion)
    }
    
    static func login(param: Parameters, completion:@escaping(Result<AESResponse, AFError>) -> Void ) {
        fetch(route: APIRouter.login(param), completion: completion)
    }
}

private extension DataResponse {
    func logs() {
        var output: [String] = []
        output.append("\n-------------------------------------------------")
        output.append("----------- REQUEST -----------------------------")
        output.append(contentsOf: request?.debugOutput ?? ["[Request]: nil"])
        output.append("\n----------- RESPONSE ----------------------------")
        output.append(response != nil ? "[Response]: \(response!)" : "[Response]: nil")
        
        switch result {
        case .success(let data):
            output.append("[Result]: Success \(data)")
        case .failure(let error):
            output.append("[Error]: \(error)")
        }
        
        output.append("[Data]: \(data.flatMap { String(data: $0, encoding: .utf8) } ?? "nil")")
        output.append("[Duration]: \(serializationDuration)")
        output.append("-------------------------------------------------\n")
        print(output.joined(separator: "\n"))
    }
}

private extension URLRequest {
    var debugOutput: [String] {
        var output: [String] = []
        output.append("[Request]: \(httpMethod ?? "GET") \(debugDescription)")
        output.append("[Headers]: \(allHTTPHeaderFields.flatMap { $0.debugDescription } ?? "nil")")
        output.append("[Body]: \(httpBody.flatMap { String(data: $0, encoding: .utf8) } ?? "nil")")

        return output
    }
}

//struct User: Codable {
//    let firstName: String
//    let lastName: String
//    let email: String
//    let image: URL
//}

struct Article : Codable{
    let id: Int
    let title: String
    let image: URL
    let author : String
    let categories: [Category]
    let datePublished: Date
    let body: String?
    let publisher: String?
    let url: URL?
}

struct Category: Codable {
    let id: Int
    let name: String
    let parentID: Int?
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case parentID = "parent_id"
    }
}

extension DateFormatter {
    static var articleDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
