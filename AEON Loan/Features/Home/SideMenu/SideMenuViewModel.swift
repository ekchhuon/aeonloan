//
//  SideMenuViewModel.swift
//  AEON Loan
//
//  Created by aeon on 12/14/20.
//

import Foundation

public class SideMenuViewModel {
    
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    
    init() {
        
    }
    
    func logout(completion: @escaping (_ success: Bool) -> Void) {
        let header = Header()
        let param = Param.Request(header: header, body: Param.Body(encode: ""))
        self.status.value = .started
        APIClient.logout(param: param.toJSON()) { result in
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message + " [\(data.body.code)]"; return
                }
                
                // erase data
                // navigate to login
                completion(data.body.success)
            case let .failure(err):
                self.error.value = err.evaluate
            }
        }
    }
}
