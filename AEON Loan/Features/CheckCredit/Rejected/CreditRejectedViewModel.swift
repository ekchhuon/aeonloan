//
//  ApplicationMessageViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import Foundation

public class CreditRejectedViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let result: Box<SubmitResult?> = Box(nil)
    
    init() {
        fetch()
    }
    
    func fetch() {
        result.value = .success
    }
    
}
