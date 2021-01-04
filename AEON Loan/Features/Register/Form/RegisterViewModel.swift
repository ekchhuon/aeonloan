//
//  RegisterViewModel.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import Foundation
import UIKit.UIImage

public class RegisterViewModel {
    private let header = Header()
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    init() {
    }
    
    func register(user: User, completion: @escaping (_ user: User) -> Void) {
        var user = user
        user.idPhoto = String.random(length: 32)
        status.value = .started
        let encrypted = user.asString.encrypt()
        let body = Param.Body(encode: encrypted)
        
        print("User====>", user)
        
//        let user = Param.Register(username: "chhuon3", phoneNumber: "95403087", email: "abc@gmail.com", password: "1234", idPhoto: String.random(length: 32), nidPassport: "12")
             
        let param = Param.Request(header: header, body: body)
        APIClient.register2(param: param.toJSON()) { (result) in
            self.status.value = .stopped

            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                let user = User(fullName: user.fullName, username: user.username, phoneNumber: user.phoneNumber, email: user.email, password: user.password, idPhoto: user.idPhoto, nidPassport: user.nidPassport)

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
    
    func checkUsername(username: String, loading: @escaping (_ loading: Bool) -> Void, completion: @escaping (_ available: Bool) -> Void)  {
        //status.value = .started
        
        loading(true)
        let username = Param.Username(userName: username)
        let encrypted = username.asString.encrypt()
        let body = Param.Body(encode: encrypted)
        let param = Param.Request(header: header, body: body)
        
        APIClient.checkUsername(param: param.toJSON()) { (result) in
            //self.status.value = .stopped
            print("Result", result)
            switch result {
            case let .success(data):                
                guard data.body.success else {
                    guard data.body.code != 406 else {
                        completion(false); return
                    }
                    self.message.value = data.body.message; return
                }
            loading(false)
            completion(true)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
}
