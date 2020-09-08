//
//  UIColor.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import Foundation
import UIKit

enum Color {
    case none
    case gray
    case primary
    case purple
    case yellow
    case red
    
    var color: UIColor {
        switch self {
        case .none:
            return .white
        case .gray:
            return .gray
        case .primary:
            return .purple
        case .purple :
            return .purple
        case .yellow:
            return .yellow
        case .red:
            return .red
        }
    }
}

extension UIColor {
    
    public class var brandGray: UIColor {
        return UIColor.init(rgb: 0x686768)
    }
    
    public class var brandPurple: UIColor {
        return UIColor.init(rgb: 0x7461CF)
    }
    
    public class var brandYellow: UIColor {
        return UIColor.init(rgb: 0xFFA822)
    }
    
    public class var brandMaginta: UIColor {
        return UIColor.init(rgb: 0xA20061)
    }

}

extension UIColor {
    convenience init(rgb: UInt) {
       self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
