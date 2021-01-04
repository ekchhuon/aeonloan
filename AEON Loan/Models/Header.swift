//
//  Header.swift
//  AEON Loan
//
//  Created by aeon on 12/12/20.
//

import Foundation
// MARK: - Header
struct Header: Codable {
    let transactionID, timestamp, lan, channel: String
    let appID, appVersion, deviceBrand, deviceModel: String
    let devicePlanform, osVersion: String
    
    init(transactionID: String = "", timestamp: String = "", lan: String = Preference.language == .en ? "01":"02", channel: String = "", appID: String = "", appVersion: String = "", deviceBrand: String = "", deviceModel: String = "", devicePlanform: String = "", osVersion:String = "") {
        self.transactionID = transactionID
        self.timestamp = timestamp
        self.lan = Preference.language == .en ? "01":"02"
        self.channel = channel
        self.appID = appID
        self.appVersion = appVersion
        self.deviceBrand = deviceBrand
        self.deviceModel = deviceModel
        self.devicePlanform = devicePlanform
        self.osVersion = osVersion
    }

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case timestamp, lan, channel
        case appID = "appId"
        case appVersion, deviceBrand, deviceModel, devicePlanform, osVersion
    }
}
