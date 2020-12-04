//
//  LoginViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation
import UIKit.UIImage

public class LoginViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let token = Box("")
    let success = Box("")
    let error: Box<APIError?> = Box(nil)
    let header = Param.Header(timestamp: "", encode: "", lan: "", channel: "", ipAddress: "", userID: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", deviceID: "", osVersion: "")
    
    init() {
        //        login(username: "", password: "")
    }
    /*
    func login(username: String, password: String) {
        loading.value = true
        APIClient.testLogin(email: "abc@gmail.com", password: "password") { result in
            self.loading.value = false
            switch result {
            case .success(let user):
                print("_____________________________")
                print(user)
                self.token.value = user.data?.token ?? ""
                
                
                let int: Int = 555
                let data = Data(from: int)
                let status = KeyChain.save(key: "MyNumber", data: data)
                print("status: ", status)
                
                if let receivedData = KeyChain.load(key: "MyNumber") {
                    let result = receivedData.to(type: Int.self)
                    print("result keycahin...: ", result)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    */
    
    func fetchRSA(completion:@escaping(RegisterResponse) -> Void) {
        
        loading.value = true
        let param = Param.MyRegister(header: header, body: "")
        
        print("param====>",param)
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
    
    func login(completion:@escaping() -> Void) {
        loading.value = true
//        let login = Param.LoginData(username: "aeonrohas", password: "2020@Loan#Aeon4User", grant_type: "password", header: header)
        
        Preference.loginUser = LoginUser(username: "aeonLoanApp", password: "Aeon@123!KH")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(header)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")

        Preference.header = "\(json!)"
        
        let login = Param.LoginData(username: "aeonrohas".encrypt(), password: "2020@Loan#Aeon4User".encrypt(), grant_type: "password", header: "\(json!)")
        
        APIClient.login(param: login.toJSON()) { (result) in
            self.loading.value = false
            switch result {
            case let .success(data):
                print("Login Success", data)
            case let .failure(err):
                print("Login error", err)
            }
        }
    }
    
    func fetch(user: User) {
        loading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading.value = false
            self.user.value = User(username: "Chhuon OK", password: "Password OK", profile: "")
        }
    }
}

struct User : Codable{
    var username, password: String
    let profile: String
}
