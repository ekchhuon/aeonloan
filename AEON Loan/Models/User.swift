//
//  User.swift
//  AEON Loan
//
//  Created by aeon on 12/12/20.
//

import Foundation
struct User : Codable{
    var fullName, username, phoneNumber, email, password, idPhoto, nidPassport: String
    
    init(fullName: String = "", username: String = "", phoneNumber: String = "", email: String = "", password: String = "", idPhoto: String = "", nidPassport: String = "") {
        self.fullName = fullName
        self.username = username
        self.phoneNumber = phoneNumber
        self.email = email
        self.password = password
        self.idPhoto = idPhoto
        self.nidPassport = nidPassport
    }
}

//import RealmSwift
//class Usera: NSObject {
//    
//}

//struct CurrentUser: Codable {
//  let name: String
//  let email: String
//}
