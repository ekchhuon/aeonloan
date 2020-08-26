//
//  CATransition+Options.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import UIKit

extension CATransition {

    struct Options {

        let type: TransitionType
        let duration: TimeInterval
        let curve: Curve

        init(type: TransitionType = .push(subtype: .fromRight), duration: TimeInterval = 0.35, curve: Curve = .default) {
            self.type = type
            self.duration = duration
            self.curve = curve
        }

        var animation: CATransition {
            let transition = type.transition
            transition.duration = duration
            transition.timingFunction = curve.timingFunction
            return transition
        }
    }

    enum TransitionType {
        case fade
        case push(subtype: CATransitionSubtype)
        case moveIn(subtype: CATransitionSubtype)
        case reveal(subtype: CATransitionSubtype)

        fileprivate var transition: CATransition {
            let transition = CATransition()
            switch self {
            case .fade:
                transition.type = .fade
            case let .push(subtype):
                transition.type = .push
                transition.subtype = subtype
            case let .moveIn(subtype):
                transition.type = .moveIn
                transition.subtype = subtype
            case let .reveal(subtype):
                transition.type = .reveal
                transition.subtype = subtype
            }
            return transition
        }
    }

    enum Curve {
        case `default`
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case custom(CGPoint, CGPoint)

        fileprivate var timingFunction: CAMediaTimingFunction {
            let function: CAMediaTimingFunction
            switch self {
            case .default:
                function = CAMediaTimingFunction(name: .default)
            case .linear:
                function = CAMediaTimingFunction(name: .linear)
            case .easeIn:
                function = CAMediaTimingFunction(name: .easeIn)
            case .easeOut:
                function = CAMediaTimingFunction(name: .easeOut)
            case .easeInOut:
                function = CAMediaTimingFunction(name: .easeInEaseOut)
            case let .custom(point1, point2):
                function = CAMediaTimingFunction(controlPoints: Float(point1.x), Float(point1.y), Float(point2.x), Float(point2.y))
            }
            return function
        }
    }
}

extension CATransition.Options {
    static let `default` = CATransition.Options()
}
