//
//  BuildConfig.swift
//  AEON Loan
//
//  Created by aeon on 10/7/20.
//

import Foundation

#if PRODUCTION
extension Constantss {
    // PROD:
    static let environment = "PRODUCTION"
//    static let server = URL(string: "https://api.v2.sharelookapp.com/v1/")!
//     static let server = "http://192.168.1.40:8182/webservice/public/v1/"
//    static let server = "http://192.168.1.40:8089/webservice/"
//    static let server = "http://192.168.169.34:8089/webservice/public/v1/" // wifi
  static let server = "http://192.168.169.34:8182/webservice/" // 2.4G
    
//    static let socket = URL(string: "wss://mbdl5ztc18.execute-api.ap-southeast-1.amazonaws.com/PROD/")!
//
//    static let web = URL(string: "https://app.sharelookapp.com/")!
}

#elseif STAGING
extension Constantss {
    // UAT:
    static let environment = "STAGING"
    //static let server = "http://192.168.169.13:8182/webservice/"
//    static let server = "http://192.168.1.40:8089/webservice/public/v1/"
//    static let socket = URL(string: "wss://ox0hdxa4si.execute-api.ap-northeast-2.amazonaws.com/UAT")!

//    static let web = URL(string: "https://uat.v2.sharelookapp.com/")!
}

#elseif DEVELOPMENT
extension Constantss {
    // Dev:
    static let environment = "DEVELOPMENT"
    //static let server = "http://192.168.169.13:8182/webservice/"
//    static let server = "http://192.168.1.40:8089/webservice/public/v1/"
//    static let socket = URL(string: "wss://tetgpx56l7.execute-api.us-east-1.amazonaws.com/DEV/")!

//    static let web = URL(string: "https://dev.v2.sharelookapp.com/")!
}
#endif

