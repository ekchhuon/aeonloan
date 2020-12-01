//
//  RegisterViewModel.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import Foundation

public class RegisterViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let error: Box<APIError?> = Box(nil)
    let success = Box("")
    
    init() {
    }
    
    func fetchRsa() {
        loading.value = true
        let header = Param.Header(timestamp: "", encode: "", lan: "", channel: "", ipAddress: "", userID: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", deviceID: "", osVersion: "")
        let param = Param.MyRegister(header: header, body: "")
        
        
        print("param====>",param)
        
        
        //        if let parameters = try JSONSerialization.jsonObject(with: param, options: []) as? [String: Any] {
        //            Alamofire.blah blah
        //        }
        
        //        if let parameters = try JSONSerialization.jsonObject(with: param, options: [] as? [String: Any]) {
        //
        //        }
        
//        let jsonUser = try! JSONEncoder().encode(param)
//        if let parameters = try! JSONSerialization.jsonObject(with: jsonUser, options: []) as? [String: Any] {
            
        APIClient.getRSA(param: param.toJSON()) { (result) in
                self.loading.value = false
                
                switch result {
                case let .success(data):
                    print("Data....Register",data)
                    self.success.value = "success: \(data)"
                    Preference.publicKey = data.data.publicKey
                    
                    print("public key", data.data.publicKey)
                case let .failure(err):
                    guard let code = err.responseCode else {
                        debugPrint("Error", err.localizedDescription)
                        self.error.value = APIError(code: 0, description: "", localized: err.localizedDescription)
                        return
                    }
                    self.error.value = APIError(code: code, description: code.description, localized: err.localizedDescription)
                }
                
            }
            
//        }
    }
    
    func register(with param: Param.Register) {
        loading.value = true
        APIClient.register(with: param) { (result) in
            self.loading.value = false
            
            switch result {
            case let .success(data):
                print("Data....Register",data)
                self.success.value = "success: \(data)"
                
            case let .failure(err):
                guard let code = err.responseCode else {
                    debugPrint("Error", err.localizedDescription)
                    self.error.value = APIError(code: 0, description: "", localized: err.localizedDescription)
                    return
                }
                self.error.value = APIError(code: code, description: code.description, localized: err.localizedDescription)
            }
        }
    }
}

struct APIError {
    let code: Int
    let description: String
    let localized: String
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
