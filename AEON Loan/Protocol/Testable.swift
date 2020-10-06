//
//  Testable.swift
//  AEON Loan
//
//  Created by aeon on 10/6/20.
//

import Foundation

protocol Flyable {
    
    /// Limit the speed of flyable
    var speedLimit: Int { get set }
    
    func fly()
}

extension Flyable {
    func fly() {
        print("Fly with speed limit: \(speedLimit)mph")
    }
}

class Bird: Flyable {
    var speedLimit = 20
}


//init() {
//    let a = Bird()
//    a.speedLimit = 500
//    a.fly()
//}
