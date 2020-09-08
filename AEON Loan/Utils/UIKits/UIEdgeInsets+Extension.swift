//
//  UIEdgeInsets+Extension.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import Foundation
import UIKit

extension UIEdgeInsets {

    static func left(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
    }

    static func right(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }

    static func bottom(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

    static func top(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
    }

    static func all(_ insets: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
    }

    static func horizontal(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    static func vertical(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    func with(left inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: inset, bottom: bottom, right: right)
    }

    func with(right inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: inset)
    }

    func with(bottom inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: inset, right: right)
    }

    func with(top inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: left, bottom: bottom, right: right)
    }
}
