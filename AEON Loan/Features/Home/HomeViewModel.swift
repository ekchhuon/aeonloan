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
    let menus : Box<[Menu]> = Box([Menu]())

    init() {
        setupMenu()
    }
    
    func setupMenu() {
        var menus: [Menu] = [Menu]()
        let names: [String] = ["menu1", "menu2", "menu3", "menu4", "menu5", "menu6"]
        let titles: [String] = ["Check Credit", "Apply Loan/Installment", "AEON SPB Product", "Promotion", "Check Your Payment Schedule", "Loan Calculation"]
        for (index, _) in names.enumerated() {
            let menu = Menu(icon: UIImage(named: names[index]) ?? UIImage(), title: NSLocalizedString(titles[index], comment: ""))
            menus.append(menu)
        }
        self.menus.value = menus
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
    let loading = Box(false)
    init() {
        fetch()
    }
    
    func fetch(){
        loading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loading.value = false
            let imageArray = [UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6")]
            self.images.value = imageArray
        }
    }
}



struct Menu {
    var icon: UIImage
    var title: String
}
