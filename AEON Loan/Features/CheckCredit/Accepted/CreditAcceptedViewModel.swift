//
//  ApplicationAcceptedViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import Foundation

public class CreditAcceptedViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    let credits: Box<[Credit]?> = Box(nil)
    
    
    init() {
        fetch()
    }
    
    func fetch() {
        var credits = [Credit]()
        let products = ["PL", "GHP", "MHP", "RHP", "CHR", "AHP"]
        let amounts = ["10000", "30000", "20000", "22000", "12000", "30000"]
        
        for (index, product) in products.enumerated() {
            credits.append(Credit(product: product, amount: amounts[index]))
        }
        
        self.credits.value = credits
    }
    
}
