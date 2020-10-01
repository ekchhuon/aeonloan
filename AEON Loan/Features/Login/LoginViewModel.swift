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
    
    
    init() {
        //        login(username: "", password: "")
    }
    
    func login(username: String, password: String) {
        loading.value = true
        APIClient.testLogin(email: "abc@gmail.com", password: "password") { result in
            self.loading.value = false
            switch result {
            case .success(let user):
                print("_____________________________")
                print(user)
                self.token.value = user.data?.token ?? ""
                
            /*
             let int: Int = 555
             let data = Data(from: int)
             let status = KeyChain.save(key: "MyNumber", data: data)
             print("status: ", status)
             
             if let receivedData = KeyChain.load(key: "MyNumber") {
             let result = receivedData.to(type: Int.self)
             print("result: ", result)
             }
             */
            case .failure(let error):
                print(error.localizedDescription)
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



