//
//  LocationViewModel.swift
//  AEON Loan
//
//  Created by aeon on 12/16/20.
//

import Foundation
public class LocationViewModel {
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    let locationCode = Box("")
    
    init() {
        
    }
    
    func submit(data: Applicant) {
        var data = data
        data.workingPeriod = "5"
        data.livingPeriod = "5"
        let endcoded = data.asString.encrypt()
        print(data, endcoded)
        let header = Header()
        let body = Param.Body(encode: endcoded)
        let param = Param.Request(header: header, body: body)
        status.value = .started
        APIClient.checkCredit(param: param.toJSON()) { [weak self] (result) in
                guard let self = self else {return}
                self.status.value = .stopped
                switch result {
                case let .success(data):
                    print(data)
//                    guard data.body.success else {
//                        self.message.value = data.body.message + " [\(data.body.code)]"
//                        return
//                    }
//                    self.response.value = data.body.data
                case let .failure(err):
                self.error.value = err.evaluate
                }
        }
    }
    
}
