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
    
    init() {
        
    }
    
}
