//
//  OTPViewModel.swift
//  AEON Loan
//
//  Created by aeon on 10/2/20.
//

import Foundation

public class OTPViewModel {
//    let defaults = "Loading..."
//    let user: Box<User?> = Box(nil)
//    let username = Box("")
//    let password = Box("")
    
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    let header = Header(transactionID: "", timestamp: "", lan: "", channel: "", appID: "", appVersion: "", deviceBrand: "", deviceModel: "", devicePlanform: "", osVersion: "")
    
    init() {
         requestOTP()
    }
    
    private func requestOTP() {
        self.status.value = .started
        let param = Param.Request(header: header, body: Param.Body(encode: ""))
        APIClient.getOTP(param: param.toJSON()) { (result) in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                self.response.value = data
            case let .failure(err):
                self.message.value = err.localizedDescription
            }
        }
    }
    
    func verifyOTP(otp: String, completion: @escaping (_ success: Bool) -> Void) {
        status.value = .started
        let otp = Param.OTP(code: otp)
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(otp)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\\", with: "")
        
        let param = Param.Request(header: header, body: Param.Body(encode: "\(json!)".encrypt()))
        
        APIClient.verifyOTP(param: param.toJSON()) { (result) in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                completion(data.body.success)
            case let .failure(err):
                self.message.value = err.localizedDescription
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



