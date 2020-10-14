//
//  KeychainConfiguration.swift
//  AEON Loan
//
//  Created by aeon on 10/14/20.
//

import Foundation

struct KeychainConfiguration2 {
    static let serviceName = "MyAppService"
    
    /*
        Specifying an access group to use with `KeychainPasswordItem` instances
        will create items shared accross both apps.
    
        For information on App ID prefixes, see:
            https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html
        and:
            https://developer.apple.com/library/ios/technotes/tn2311/_index.html
    */
//    static let accessGroup = "[YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared"

    /*
        Not specifying an access group to use with `KeychainPasswordItem` instances
        will create items specific to each app.
    */
    static let accessGroup: String? = nil
}
