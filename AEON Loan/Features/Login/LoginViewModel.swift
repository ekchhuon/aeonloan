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
    
    init() {
//        login(username: "", password: "")
    }
    
    func login(username: String, password: String) {
        let user = User(username: username, password: password, profile: "")
        fetch(user: user)
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



