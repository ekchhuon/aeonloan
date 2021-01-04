//
//  PaymentScheduleViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import Foundation

public class PaymentScheduleViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    init() {
        fetchPaymentSchedule(data: Applicant())
    }
    
    func fetchPaymentSchedule(data: Applicant) {
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
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
}
