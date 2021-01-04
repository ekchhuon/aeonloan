//
//  HomeViewModel.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//

import Foundation
import UIKit.UIImage

public class HomeViewModel {
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    let imageURLs: Box<[URL?]> = Box([URL]()) // slideshow
    let images: Box<[UIImage]?> = Box(nil)
    
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let menus : Box<[Menu]> = Box([Menu]())

    init() {
        setupMenu()
        fetchSlideShow()
    }
    
    func setupMenu() {
        var menus: [Menu] = [Menu]()
        let names: [String] = ["menu1", "menu2", "menu3", "menu4", "menu5", "menu6"]
        let titles: [String] = ["Check Credit", "Apply Loan/Installment", "AEON Products", "Promotion", "Payment Schedule", "Loan Calculation"]
        for (index, _) in names.enumerated() {
            let menu = Menu(icon: UIImage(named: names[index]) ?? UIImage(), title: titles[index].localized)
            menus.append(menu)
        }
        self.menus.value = menus
    }
    
    /*
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
    */
    
    private func createImageURL(with imageIds: [String]?) {
        guard let imageIds = imageIds else {
            print("ImageID Not Found"); return
        }
        var urls = [URL]()
        let path = Constant.server + "public/v1/slide_image/"
        imageIds.forEach { id in
            guard let url = URL(string: path + id) else {
                print("Unable to convert string to URL"); return
            }
            urls.append(url)
        }
        self.imageURLs.value = urls
    }
    
//    private func createImage(with imageIds: [String]?) {
//        guard let imageIds = imageIds else {
//            print("ImageID Not Found"); return
//        }
//        var urls = [URL]()
//        var images = [UIImage]()
//        let path = Constant.server + "public/v1/slide_image/"
//        imageIds.forEach { id in
//            guard let url = URL(string: path + id) else {
//                print("Unable to convert string to URL"); return
//            }
//            let aaa = UIImageView().load(url: url)
//        }
//        self.imageURLs.value = urls
//    }
    
    func fetchSlideShow() {
        let header = Header()
        let body = Param.Body(encode: "")
        let param = Param.Request(header: header, body: body)
        
        status.value = .started
        APIClient.slideShow(param: param.toJSON()) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                print(data)
                guard data.body.success else {
                    self.message.value = data.body.message + " [\(data.body.code)]"
                    return
                }
                self.createImageURL(with: data.body.data)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
    func fetch(user: User) {
        loading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading.value = false
            self.user.value = User()
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

