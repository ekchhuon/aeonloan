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
    
}
