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
    let isRegisterSuccess = Box(false)
    let header = Param.Header(timestamp: "", encode: "", lan: "", channel: "", ipAddress: "", userID: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", deviceID: "", osVersion: "")
    
    init() {
    }
    
    func submitAES(encryption body: String, completion:@escaping() -> Void) {
        loading.value = true
        
        let param = Param.MyRegister2(header: header, body: Param.Body(encode: body))
        
        APIClient.submitEncryption(param: param.toJSON()) { (result) in
            self.loading.value = false
            switch result {
            case let .success(data):
                print("AES Success==>:",data)
                completion()
                //self.register2()
            case let .failure(err):
                print("AES Errror==>:",err)
            }
        }
    }
    
    func fetchRSA(completion:@escaping(RegisterResponse) -> Void) {
        
        loading.value = true
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
//                    Preference.sha256 = data.data.publicKey
                    print("public key", data.data.publicKey)
                    completion(data)
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
    
    func register2() {
        
        loading.value = true
//        let user = Param.Register(username: "chhuon", phoneNumber: "012234501", email: "abc@gmail.com", password: "1234".bcrypted)
        
        let user = Param.Register(username: "chhuon2", phoneNumber: "01234502", email: "abc@gmail.com", password: "1234", idPhoto: String.random(length: 32), nidPassport: "12")
        
        let string = "\(user)"
        
        
        
        let userString = String(describing: user)
        
        let replaced = userString.replacingOccurrences(of: "[", with: "{").replacingOccurrences(of: "]", with: "}")
        
//        print("replaced", replaced, userString, user )
//        print("stringjson", string, user)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(user)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")
        
        
        let param = Param.MyRegister2(header: header, body: Param.Body(encode: "\(json!)".encrypt()))
        
        APIClient.register2(param: param.toJSON()) { (result) in
            self.loading.value = false
            
            print("resultuser====>", result)
            switch result {
            case let .success(data):
                print("RegisterSuccess Success==>:",data)
                self.isRegisterSuccess.value = data.success
            case let .failure(err):
                self.isRegisterSuccess.value = false
                print("Register Error Errror==>:",err)
             }
        }
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
