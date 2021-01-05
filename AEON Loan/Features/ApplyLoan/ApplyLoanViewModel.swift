//
//  ApplyLoanViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/11/20.
//

import Foundation

public class ApplyLoanViewModel {
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Loan?> = Box(nil)
    var products: Box<[CheckCredit.ProductOffer]?> = Box(nil)
    
    init() {
        fetchCheckCreditStatus()
    }
    
    func submit(data: ApplyLoan) {
        let endcoded = data.asString.encrypt()
        print(data, endcoded)
        let header = Header()
        let body = Param.Body(encode: endcoded)
        let param = Param.Request(header: header, body: body)
        status.value = .started
        APIClient.applyLoan(param: param.toJSON()) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message + " [\(data.body.code)]"
                    return
                }
                self.response.value = data
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
    
    func fetchCheckCreditStatus() {
        let header = Header()
        let body = Param.Body(encode: "")
        let param = Param.Request(header: header, body: body)
        status.value = .started
        APIClient.checkCreditStatus(param: param.toJSON()) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                print(data)
                guard data.body.success else {
                    self.message.value = data.body.message + " [\(data.body.code)]"
                    return
                }
                //self.response.value = data
                self.products.value = data.body.data?.productOffer
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
}

