//
//  RegisterViewModel.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import Foundation
import UIKit.UIImage

public class RegisterViewModel {

    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    let header = Header(transactionID: "", timestamp: "", lan: "", channel: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", osVersion: "")
    
    init() {
    }
    
    func register(completion: @escaping (_ user: User) -> Void) {
        status.value = .started
        let user = Param.Register(username: "chhuon3", phoneNumber: "95403087", email: "abc@gmail.com", password: "1234", idPhoto: String.random(length: 32), nidPassport: "12")
             
        
        let param = Param.Request(header: header, body: Param.Body(encode: user.asString.encrypt()))
        
        APIClient.register2(param: param.toJSON()) { (result) in
            self.status.value = .stopped

            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                
                let user = User(username: user.username, phoneNumber: user.phoneNumber, email: user.email, password: user.password, idPhoto: user.idPhoto, nidPassport: user.nidPassport)
                completion(user)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
        
        
        
    }
    
    func upload(_ route:UploadAPIRouter, image: UIImage, progress: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ result: Bool) -> Void)  {
        self.status.value = .started
        APIClient.upload(route, image: image, progress: progress) { result in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                completion(data.body.success)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
//    func register(with param: Param.Register) {
//        loading.value = true
//        APIClient.register(with: param) { (result) in
//            self.loading.value = false
//
//            switch result {
//            case let .success(data):
//                print("Data....Register",data)
//                self.success.value = "success: \(data)"
//            case let .failure(err):
//                guard let code = err.responseCode else {
//                    debugPrint("Error", err.localizedDescription)
//                    self.error.value = APIError(code: 0, description: "", localized: err.localizedDescription)
//                    return
//                }
//                self.error.value = APIError(code: code, description: code.description, localized: err.localizedDescription)
//            }
//        }
//    }
}

extension Encodable {
    func toJSON() -> [String:Any] {
        let codableData = try? JSONEncoder().encode(self)
        if let param = try? JSONSerialization.jsonObject(with: codableData ?? Data(), options: []) as? [String: Any] {
            return param
        }
        
        return [:]
    }
}


extension Encodable {
    var asString: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "") ?? ""
    }
}
