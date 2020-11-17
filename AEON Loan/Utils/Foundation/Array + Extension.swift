//
//  Array + Extension.swift
//  AEON Loan
//
//  Created by aeon on 11/11/20.
//

import Foundation
import UIKit.UITextField

// MARK: - String
extension Array where Element == String {
    // find words/chars in string array
    func find(_ searchText: [String]) -> [String] {
        let finderSet:Set<String> = Set(searchText)
        let filteredArray = self.filter {
            return Set($0.lowercased().map({String($0.lowercased())})).intersection(finderSet).count == searchText.count
        }
        return filteredArray
    }
    
    // find a word/char in string array
    func find(_ searchText: String) -> [String] {
        let matched = self.filter {
            return $0.lowercased().contains(searchText.lowercased())
        }
        return matched
    }
    
    // contains
    func has(_ searchText: String) -> Bool {
        let filter = self.filter {
            return  $0.range(of: searchText, options: .caseInsensitive) != nil
        }
        return filter.count > 0
    }
    
    // return exact word
    func hasExact(_ searchText: String)  -> Bool {
        return self.contains { $0 == searchText }
    }
    
    func getItem(using regex: String) -> String? {
        let filtered = self.filter {
            return  $0.range(of: regex, options: .regularExpression) != nil
        }
        return filtered[0]
    }
    
    // extract id
    func getIdNumber(for document: DocumentType) -> String {
        return getItem(using: document.regex) ?? ""
    }
    
    func hasId(_ type: DocumentType) -> Bool {
        return (getItem(using: type.regex) != nil)
    }
}

// MARK: - UITextField
extension Array where Element == UITextField {
    /// ensure all fields have value
    var hasValue: Bool {
        return !(self.contains{ $0.text?.isEmpty ?? false })
    }
}
