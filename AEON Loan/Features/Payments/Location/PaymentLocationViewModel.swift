//
//  PaymentLocationViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import Foundation

public class PaymentLocationViewModel {
    let defaults = "Loading..."
    let object: Box<User?> = Box(nil)
    let string = Box("")
    let loading = Box(false)
    let channels: Box<[Channel]> = Box([Channel]())
    
    init() {
        setupMockData()
    }
    
    /*
    func login(username: String, password: String) {
        
        APIClient.testLogin(email: "abc@gmail.com", password: "") { result in
            switch result {
            case .success(let user):
                print("_____________________________")
                print(user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    */
    
    func setupMockData() {
        var channels: [Channel] = [Channel]()
        let names = ["Acleda", "BOC", "CPB", "CIMB", "MayBank", "TrueMoney", "Wing"]
        let accounts = ["0000001", "0000002", "0000003", "0000004", "0000005", "0000006", "0000007"]
        let autoDebits = [true, false, false, false, true, true, true, true]
        let counterFees = ["0.50","0.40","0.30", "0.40","0.50","0.40","0.30"]
        let mobileFees = ["0.25", "N/A", "N/A", "N/A", "0.0", "0.40", "0.50"]
        
        for (i, _) in names.enumerated() {
            let channel = Channel(name: names[i], account: accounts[i], isAutoDebit: autoDebits[i], counterFee: counterFees[i], mobileFee: mobileFees[i])
            channels.append(channel)
        }
        self.channels.value = channels
        
    }
    
    func fetch(user: User) {
        loading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading.value = false
            // stuff
        }
    }
    
    
}


struct Channel {
    var name, account: String
    var isAutoDebit: Bool
    var counterFee, mobileFee: String
}


