//
//  ApplicantInfoViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import Foundation
public class ApplicantInfoViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    var maritals = Box([String]())
    var occupations = Box([String]())
    var educations = Box([String]())
    var periods = Box([String]())
    
    init() {
        setupDummy()
    }
    
    func setupDummy() {
        loading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loading.value = false
            self.maritals.value = [ "Single", "Married", "Divoced"]
            self.occupations.value = ["Teacher", "Accountant", "Consultant", "Engineer", "Programmer"]
            self.educations.value = ["Primary School", "Middle School" ,"BacII", "Colledge"]
            self.periods.value = ["6M", "6-12M", "12-36M", "36-60M", "60M" ]
        }
    }
}
