//
//  LoginViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import Foundation
import UIKit.UIImage

public class LoginViewModel {
    let user: Box<User?> = Box(nil)
    
    init() {
//        login(username: "", password: "")
    }
    
    func login(username: String, password: String) {
        let user = User(username: username, password: password, profile: "")
        fetch(user: user)
    }
    
    func fetch(user: User) {
        print("user=======>", user)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.user.value?.username = "Chhuon True"
            self.user.value?.password = "pwd true"
        }
    }
    
}

struct User : Codable{
    var username, password: String
    let profile: String
}



