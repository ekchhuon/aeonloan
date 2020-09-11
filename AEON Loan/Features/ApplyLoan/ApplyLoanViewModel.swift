//
//  ApplyLoanViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/11/20.
//

import Foundation

public class ApplyLoanViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    init() {
        
    }

    
}
