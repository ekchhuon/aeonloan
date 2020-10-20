//
//  Calculator.swift
//  AEON Loan
//
//  Created by aeon on 10/20/20.
//

import Foundation
public class CalculatorViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    init() {
        
    }
    
}
