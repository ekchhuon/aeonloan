//
//  HomeViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//

import Foundation
import UIKit.UIImage

public class HomeViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    init() {
        //        login(username: "", password: "")
    }
    
    func login(username: String, password: String) {
        
        APIClient.testLogin(email: "abc@gmail.com", password: "") { result in
            switch result {
            case .success(let user):
                print("_____________________________")
                print(user)
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

public class SliderViewModel {
    let images : Box<[UIImage?]?> = Box(nil)
    let numbers: Box<[String]?> = Box(nil)
    let loading = Box(false)
    init() {
        fetch()
    }
    
    func fetch(){
        loading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading.value = false
            let imageArray = [UIImage(named: "leaf"), UIImage(named: "leaf.fill"), UIImage(named: "leaf"), UIImage(named: "leaf.fill"), UIImage(named: "leaf"), UIImage(named: "leaf.fill")]
            
            self.images.value = imageArray
        
            
            let numbers = ["1", "2", "3", "4", "5", "6"]
            
            self.numbers.value = numbers
        }
    }
}
