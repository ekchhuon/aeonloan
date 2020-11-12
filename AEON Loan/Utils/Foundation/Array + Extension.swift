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
    
    // exact the word
    func hasExact(_ searchText: String)  -> Bool {
        return self.contains { $0 == searchText }
    }
    
    // has exact number of digit. eg. ^[0-9]{9}$ = 012345678 (nine digit)
    func findDigit(of digit: Int) -> [String] {
        let filtered = self.filter {
            return  $0.range(of: "^[0-9]{\(digit)}$", options: .regularExpression) != nil
        }
        return filtered
    }
    
    func hasDigit(of digit: Int) -> Bool {
        let results = findDigit(of: digit)
        return results.count > 0
    }
}

// MARK: - UITextField
extension Array where Element == UITextField {
    /// ensure all fields have value
    var hasValue: Bool {
        return !(self.contains{ $0.text?.isEmpty ?? false })
    }
}
