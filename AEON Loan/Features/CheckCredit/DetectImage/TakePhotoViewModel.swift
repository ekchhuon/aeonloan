//
//  TakePhotoViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import Foundation
public class TakePhotoViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    init() {
        
    }
    
}
