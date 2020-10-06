//
//  ModelRepresentable.swift
//  AEON Loan
//
//  Created by aeon on 10/6/20.
//

import Foundation

protocol ModelRepresentable: Codable {
    var timestamp: Int32 { get set }
    var success: Bool { get set}
    var message: String { get set }
    var code: Int { get set }
}
