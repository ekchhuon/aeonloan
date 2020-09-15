//
//  UIButton.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import Foundation
import UIKit

extension UIButton {
    func setBorder(radius: CGFloat = 5, title titleColor: Color = .gray , border borderColor: Color, width: CGFloat = 1, bg: Color = .none, alpha: CGFloat = 1) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.color.cgColor
        self.setTitleColor(titleColor.color, for: .normal)
        self.alpha = alpha
        self.layer.backgroundColor = bg.color.cgColor
        
    }
    
    func rounds(radius: CGFloat = 5, background bgColor:UIColor = .white, border borderColor: UIColor = .clear, width: CGFloat = 0) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
//        self.setTitleColor(titleColor.color, for: .normal)
//        self.alpha = alpha
        self.layer.backgroundColor = bgColor.cgColor
        
    }
}
