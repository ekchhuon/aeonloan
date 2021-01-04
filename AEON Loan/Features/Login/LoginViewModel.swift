//
//  LoginViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation
import UIKit.UIImage
import Alamofire

public class LoginViewModel {
////    let defaults = "Loading..."
////    let user: Box<User?> = Box(nil)
////    let username = Box("")
////    let password = Box("")
//    let loading = Box(false)
////    let token = Box("")
////    let success = Box("")
//    
////    let fetching = Box(false)
//    let error: Box<APIError?> = Box(nil)
//    let message: Box<String?> = Box(nil)
    
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    let headerLogin = Header(transactionID: "00111", timestamp: "12345", lan: "en", channel: "maybank", appID: "12345", appVersion: "1.0.1", deviceBrand: "iOS", deviceModel: "i8P", devicePlanform: "iOS", osVersion: "14.0")
    

    let header = Header(transactionID: "", timestamp: "", lan: "", channel: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", osVersion: "")
    
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
    
    func login(username: String, password: String, completion:@escaping(Login) -> Void) {
        requestAuth { [weak self] in
            guard let self = self else {return}
            
            print("user===>", username, password)
            
            let user = Param.LoginData(username: username, password: password, grant_type: "password", deviceId: "12345")
            
            print("username, password", user)
            
            let param = Param.Request(header: self.headerLogin, body: Param.Body(encode: user.asString.encrypt()))
            
            print("USER:", user)
            print("PARAM:", param)
            print("PARAM.toJSON:", param.toJSON())
            
            self.status.value = .started
            APIClient.login(param: param.toJSON()) { (result) in
                self.status.value = .stopped
                switch result {
                case let .success(data):
                    print("Login Success", data)
                    
                    if let error = data.errorDescription {
                        self.message.value = error
                    } else {
                        // success
                        Preference.accessToken = data.accessToken
                        Preference.refreshToken = data.refreshToken
                        
                        // save user to keychain
                        do {
                            try AuthController.signIn(User(username: username), password: password)
                        } catch {
                          print("Error signing in: \(error.localizedDescription)")
                        }
                        
                        guard AuthController.isSignedIn else {
                            debugPrint("issue saving user to keychain"); return
                        }
                        completion(data)
                    }
                    
                case let .failure(err):
                    self.error.value = err.evaluate
                }
            }
            
        }
    }
    
    func requestAuth(completion:@escaping() -> Void) {
        // 1. Fetch RSA
        // 2. Fetch AES
        // 3. Do stuff...
        fetchRSA { [weak self] publicKey in
            guard let self = self else { return }
            let sha256 = String.random(length: 5).asSha256
            guard let encrypted = RSA.encrypt(string: sha256, publicKey: publicKey) else {
                debugPrint("Error: Unable to encrypt rsa"); return
            }
            
            self.submitAES(encryption: encrypted) {
                do {
                    try AuthController.saveSHA(sha256)
                } catch {
                  print("Error signing in: \(error.localizedDescription)")
                }
                
                completion()
            }
        }
    }
    func fetchRSA(completion:@escaping(String) -> Void) {
        let param = Param.Request(header: header, body: Param.Body(encode: ""))
        self.status.value = .started
        APIClient.getRSA(param: param.toJSON()) { (result) in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                completion(data.body.data!.publicKey)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
    func submitAES(encryption body: String, completion:@escaping() -> Void) {
        let param = Param.Request(header: header, body: Param.Body(encode: body))
        self.status.value = .started
        APIClient.submitEncryption(param: param.toJSON()) { (result) in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                completion()
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
    /*
    
    func login(completion:@escaping() -> Void) {
        loading.value = true
//        let login = Param.LoginData(username: "aeonrohas", password: "2020@Loan#Aeon4User", grant_type: "password", header: header)
        
        Preference.loginUser = LoginUser(username: "aeonLoanApp", password: "Aeon@123!KH")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(header)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")

        Preference.header = "\(json!)"
        
//        let login = Param.LoginData(username: "aeonrohas".encrypt(), password: "2020@Loan#Aeon4User".encrypt(), grant_type: "password", header: "\(json!)")
        
//        APIClient.login(param: login.toJSON()) { (result) in
//            self.loading.value = false
//            switch result {
//            case let .success(data):
//                print("Login Success", data)
//            case let .failure(err):
//                print("Login error", err)
//            }
//        }
    }
    */
}





