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
        return AF.request(route).validate().responseDecodable (decoder: decoder){ (response: DataResponse<M, AFError>) in
                            response.logs()
                            completion(response.result)
        }
    }
    
    private static func uploadMultipart<M:Decodable>(route:UploadAPIRouter, image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion:@escaping (Result<M, AFError>)->Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        let parameters = ["encode": String.random(length: 32).encrypt()]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "file",
                                         fileName: "\(Date().currentTimeMillis())",
                                         mimeType: "image/jpeg")
                
                for (key, value) in parameters {
                    multipartFormData.append(value.asData, withName: key)
                }
            },
            to: route.url!  , usingThreshold: UInt64.init(), method: .post)
            
            .uploadProgress { progress in
                progressCompletion(Float(progress.fractionCompleted))
            }
            
            .responseDecodable { (response: DataResponse<M, AFError>) in
                completion(response.result)
                response.logs()
            }
    }
    
    static func register(with param: Param.Register, completion:@escaping(Result<Register, AFError>) -> Void) {
        fetch(route: APIRouter.register(param: param), completion: completion)
    }
    
    static func getRSA(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void) {
        fetch(route: APIRouter.rsa(param: param), completion: completion)
    }
    
    static func submitEncryption(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void) {
        fetch(route: APIRouter.aes(param: param), completion: completion)
    }
    
    static func register2(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void ) {
        fetch(route: APIRouter.register2(param: param), completion: completion)
    }
    
    static func getOTP(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void ) {
        fetch(route: APIRouter.getOTP(param: param), completion: completion)
    }
    
    static func verifyOTP(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void ) {
        fetch(route: APIRouter.verifyOTP(param: param), completion: completion)
    }
    
    static func login(param: Parameters, completion:@escaping(Result<Login, AFError>) -> Void ) {
        fetch(route: APIRouter.login(param), completion: completion)
    }
    
    static func upload(_ route:UploadAPIRouter, image: UIImage, progress: @escaping (_ percent: Float) -> Void,
                              completion:@escaping(Result<Response, AFError>) -> Void)  {
        uploadMultipart(route: route, image: image, progressCompletion: progress, completion: completion)
    }
    
    static func logout(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void ) {
        fetch(route: APIRouter.logout(param), completion: completion)
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

struct ImageUpload {
    let success: Bool
    let status: Int
}
