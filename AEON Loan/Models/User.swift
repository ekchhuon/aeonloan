//
//  User.swift
//  AEON Loan
//
//  Created by aeon on 12/12/20.
//

import Foundation
struct User : Codable{
    let username, phoneNumber, email, password, idPhoto, nidPassport: String
    
    init(username: String = "", phoneNumber: String = "", email: String = "", password: String = "", idPhoto: String = "", nidPassport: String = "") {
        self.username = username
        self.phoneNumber = phoneNumber
        self.email = email
        self.password = password
        self.idPhoto = idPhoto
        self.nidPassport = nidPassport
    }
}
