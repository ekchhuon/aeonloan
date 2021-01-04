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
        
        guard let imageData = image.jpegData(compressionQuality: 0.50) else {
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
    
    static func checkUsername(param: Parameters, completion:@escaping(Result<Response, AFError>) -> Void ) {
        fetch(route: APIRouter.checkUsername(param), completion: completion)
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

// Location
enum ParamLocation {
    case province(Parameters), district(Parameters), commune(Parameters), village(Parameters)
}
extension APIClient {
    static func getLocation(for location: ParamLocation, completion:@escaping(Result<Location, AFError>) -> Void ) {
        switch location {
        case let .province(param):
            fetch(route: APIRouter.location(.province(param)), completion: completion)
        case let .district(param):
            fetch(route: APIRouter.location(.district(param)), completion: completion)
        case let .commune(param):
            fetch(route: APIRouter.location(.commune(param)), completion: completion)
        case let .village(param):
            fetch(route: APIRouter.location(.village(param)), completion: completion)
        }
        
    }
}

extension APIClient {
    static func fetchVariable(_ variable: VariableType,  param: Parameters, completion:@escaping(Result<Variable, AFError>) -> Void ) {
        switch variable {
        case .workingPeriod:
            fetch(route: APIRouter.workingPeriod(param), completion: completion)
        case .livingPeriod:
            fetch(route: APIRouter.livingPeriod(param), completion: completion)
        case .occupation:
            fetch(route: APIRouter.occupation(param), completion: completion)
        case .maritalStatus:
            fetch(route: APIRouter.maritialStatus(param), completion: completion)
        case .education:
            fetch(route: APIRouter.education(param), completion: completion)
        case .gender:
            fetch(route: APIRouter.gender(param), completion: completion)
        case .houseType:
            fetch(route: APIRouter.housingType(param), completion: completion)
        }
    }
    
    static func checkCredit(param: Parameters, completion:@escaping(Result<CheckCredit, AFError>) -> Void ) {
        fetch(route: APIRouter.checkCredit(param), completion: completion)
    }
    //...
    static func checkCreditStatus(param: Parameters, completion:@escaping(Result<CheckCredit, AFError>) -> Void ) {
        fetch(route: APIRouter.checkCreditStatus(param), completion: completion)
    }
    
    static func slideShow(param: Parameters, completion:@escaping(Result<SlideShow, AFError>) -> Void ) {
        fetch(route: APIRouter.slideShow(param), completion: completion)
    }
    
    static func paymendSchedule(param: Parameters, completion:@escaping(Result<Login, AFError>) -> Void ) {
        fetch(route: APIRouter.paymentSchedule(param), completion: completion)
    }
    
    static func paymentScheduleDetail(param: Parameters, completion:@escaping(Result<Login, AFError>) -> Void ) {
        fetch(route: APIRouter.paymentScheduleDetail(param), completion: completion)
    }
    
    static func applyLoan(param: Parameters, completion:@escaping(Result<Login, AFError>) -> Void ) {
        fetch(route: APIRouter.loan(param), completion: completion)
    }
    
    static func getNotification(param: Parameters, completion:@escaping(Result<Login, AFError>) -> Void ) {
        fetch(route: APIRouter.loan(param), completion: completion)
    }
}

