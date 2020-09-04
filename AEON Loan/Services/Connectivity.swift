//
//  Connectivity.swift
//  AEON Loan
//
//  Created by aeon on 9/4/20.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
