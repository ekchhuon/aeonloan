//
//  UIImageView + Extenstion.swift
//  AEON Loan
//
//  Created by aeon on 9/29/20.
//

import Foundation
import UIKit


// get size of img
extension UIImage {
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    
    func getSizeIn(_ type: DataUnits)-> String {
        
        guard let data = self.pngData() else {
            return ""
        }
        
        var size: Double = 0.0
        
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        
        return String(format: "%.2f", size)
    }
    
    func withColor(_ color: UIColor) -> UIImage {
        self.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
