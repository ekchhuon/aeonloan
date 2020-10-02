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
    let error = Box("")
    let success = Box("")
    init() {
        
    }
    
    func fetch() {
        
    }
    
    func login(username: String, password: String) {
        loading.value = true
        APIClient.testLogin(email: "abc@gmail.com", password: "password") { result in
            
            switch result {
            case .success(let user):
                print(user)
            //                self.token.value = user.data?.token ?? ""
            case .failure(let error):
                print(error.localizedDescription)
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
                self.success.value = "success: \(data.success)"
            case let .failure(err):
                print("Error....register",err)
                self.error.value = err.localizedDescription
            }
        }
    }
}
