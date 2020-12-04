//
//  OTPViewModel.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import Foundation

public class OTPViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let header = Param.Header(timestamp: "", encode: "", lan: "", channel: "", ipAddress: "", userID: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", deviceID: "", osVersion: "")
    
    init() {
        getOTP()
    }
    
    func getOTP() {
        loading.value = true
        let param = Param.MyRegister(header: header, body: "")
        APIClient.getOTP(param: param.toJSON()) { (result) in
            self.loading.value = false
            switch result {
            case let .success(data):
                print("OTP Response", data)
            case let .failure(err):
                print("OTP Response", err)
            }
        }
    }
    
    func verifyOTP(otp: String) {
        loading.value = true
        
        let otp = Param.OTP(code: otp)
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(otp)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")
        
        let param = Param.MyRegister2(header: header, body: Param.Body(encode: "\(json!)".encrypt()))
        
        APIClient.verifyOTP(param: param.toJSON()) { (result) in
            self.loading.value = false
            switch result {
            case let .success(data):
                print("Verifiy Response", data)
            case let .failure(err):
                print("Verifiy Response", err)
            }
        }
    }
    
}

struct OTP: Codable {
    let timestamp: Int
    let success: Bool
    let message: String
    let code: Int
    let data: DataClass
    // MARK: - DataClass
    struct DataClass: Codable {
        let code, timeout: Int
    }
}



