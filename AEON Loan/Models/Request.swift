//
//  Request.swift
//  AEON Loan
//
//  Created by aeon on 12/12/20.
//

import Foundation

struct Param {
    struct Register: Codable {
        let username: String
        let phoneNumber: String
        let email: String
        let password: String
        let idPhoto: String
        let nidPassport: String
    }
    
    // MARK: - Register
    struct MyRegister: Codable {
        let header: Header
        let body: String
    }
    
    struct Province: Codable {
        let header: Header
        let body: String
    }
    
    struct District: Codable {
        let header: Header
        let body: Body
        struct Body: Codable {
            let provinceCode: String
        }
    }
    
    struct Commune: Codable {
        let header: Header
        let body: Body
        struct Body: Codable {
            let districtCode: String
        }
    }
    
    struct Village: Codable {
        let header: Header
        let body: Body
        struct Body: Codable {
            let communeCode: String
        }
    }
    
    struct Variable: Codable {
        let header: Header
        let body: Body
        struct Body: Codable {
            let id: String
        }
    }
    
    
    
//    // MARK: - Header
//    struct Header: Codable {
//        let transactionId ,timestamp, lan, channel: String
//        let appID, appVersion: String
//        let deviceBrand, deviceModel, devicePlanform: String
//        let osVersion: String
//        
//        enum CodingKeys: String, CodingKey {
//            case transactionId,timestamp, lan, channel
//            case appID = "appId"
//            case appVersion, deviceBrand, deviceModel, devicePlanform
//            case osVersion
//        }
//    }
    
    // MARK: - Register
    struct Request: Codable {
        let header: Header
        let body: Body
    }
    
    // MARK: - Body
    struct Body: Codable {
        let encode: String
    }
    
    struct OTP: Codable {
        let code: String
    }
    
    struct LoginData: Codable {
        let username, password, grant_type, deviceId: String
    }
}
