//
//  UIView+Layout.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit

private let borderTopTag = 500
private let borderLeftTag = 501
private let borderBottomTag = 502
private let borderRigthTag = 503
private let separatorTag = 504

extension UIView {
    
    struct ViewEdge: OptionSet {
        let rawValue: Int
        
        static let left = ViewEdge(rawValue: 1 << 0)
        static let top = ViewEdge(rawValue: 1 << 1)
        static let right = ViewEdge(rawValue: 1 << 2)
        static let bottom = ViewEdge(rawValue: 1 << 3)
        
        static let all: ViewEdge = [.left, .top, .right, .bottom]
    }
    
    func pinInSuperview(to edges: ViewEdge, with insets: UIEdgeInsets = .zero) {
        
        guard let superview = self.superview else { return }
        guard !edges.isEmpty else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
        }
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillInSuperview(with insets: UIEdgeInsets = .zero) {
        pinInSuperview(to: .all, with: insets)
    }
    
    func centerInSuperview(with offset: UIOffset = .zero) {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerXInSuperview(with offset: CGFloat = 0) {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset).isActive = true
    }
    
    func centerYInSuperview(with offset: CGFloat = 0) {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset).isActive = true
    }
    
    func constraint(equalTo size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension NSLayoutConstraint {
    func activate() {
        isActive = true
    }
    
    func deactivate() {
        isActive = false
    }
}

extension UIView {
    
    // swiftlint:disable function_body_length
    func addBorder(to edges: ViewEdge, with backgroundColor: UIColor = UIColor.gray, withInsets: UIEdgeInsets = .zero) {
        
        guard !edges.isEmpty else { return }
        
        func makeView(_ vertical: Bool) -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = backgroundColor
            (vertical ? view.widthAnchor : view.heightAnchor).constraint(equalToConstant: 1).isActive = true
            addSubview(view)
            return view
        }
        
        if edges.contains(.left) {
            if let border = viewWithTag(borderLeftTag) {
                border.backgroundColor = backgroundColor
            } else {
                let border = makeView(true)
                border.tag = borderLeftTag
                border.pinInSuperview(to: [.left, .top, .bottom], with: .init(top: withInsets.top, left: 0, bottom: withInsets.bottom, right: 0))
            }
        } else {
            viewWithTag(borderLeftTag)?.removeFromSuperview()
        }
        
        if edges.contains(.top) {
            if let border = viewWithTag(borderTopTag) {
                border.backgroundColor = backgroundColor
            } else {
                let border = makeView(false)
                border.tag = borderTopTag
                border.pinInSuperview(to: [.left, .top, .right], with: .init(top: 0, left: withInsets.left, bottom: 0, right: withInsets.right))
            }
        } else {
            viewWithTag(borderTopTag)?.removeFromSuperview()
        }
        
        if edges.contains(.right) {
            if let border = viewWithTag(borderRigthTag) {
                border.backgroundColor = backgroundColor
            } else {
                let border = makeView(true)
                border.tag = borderRigthTag
                border.pinInSuperview(to: [.top, .right, .bottom], with: .init(top: withInsets.top, left: 0, bottom: withInsets.bottom, right: 0))
            }
        } else {
            viewWithTag(borderRigthTag)?.removeFromSuperview()
        }
        
        if edges.contains(.bottom) {
            if let border = viewWithTag(borderBottomTag) {
                border.backgroundColor = backgroundColor
            } else {
                let border = makeView(false)
                border.tag = borderBottomTag
                border.pinInSuperview(to: [.left, .bottom, .right], with: .init(top: 0, left: withInsets.left, bottom: 0, right: withInsets.right))
            }
        } else {
            viewWithTag(borderBottomTag)?.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func addSeparator(color: UIColor = UIColor.gray /*Asset.Colors.darkGray3.color*/) {
        if let separator = viewWithTag(separatorTag) {
            separator.backgroundColor = color
            return
        }
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = separatorTag
        view.backgroundColor = color
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        addSubview(view)
        view.pinInSuperview(to: [.left, .right, .bottom], with: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func removeSeparator() {
        if let separator = viewWithTag(separatorTag) {
            separator.removeFromSuperview()
            return
        }
    }
}

extension UIView {
    
    func addShadow() {
        
        layer.shadowColor = UIColor.purple.cgColor //Asset.Colors.darkGray1.color.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
    
    func shadowWhen(scroll scrollView: UIScrollView) {
        let originY = scrollView.bounds.origin.y
        var delta = scrollView.contentSize.height - scrollView.frame.size.height
        
        if delta > 8 {
            delta = 8
        }
        
        guard originY > 0 && originY < delta else {
            if originY <= 0 {
                layer.shadowOpacity = 0
            }
            if originY > 0 {
                layer.shadowOpacity = 0.5
            }
            return
        }
        
        layer.shadowOpacity = Float(originY / delta / 2.0)
    }
}

extension UIView {
    
    func setHeight(_ constant: CGFloat) {
        var heightConstraints = constraints.filter { $0.firstAnchor == heightAnchor && $0.secondAnchor == nil }
        
        if heightConstraints.isEmpty {
            heightConstraints.append(heightAnchor.constraint(equalToConstant: constant))
        }
        
        heightConstraints.forEach {
            $0.constant = constant
            $0.activate()
        }
    }
    
    func setWidth(_ constant: CGFloat) {
        var widthConstraints = constraints.filter { $0.firstAnchor == widthAnchor && $0.secondAnchor == nil }
        
        if widthConstraints.isEmpty {
            widthConstraints.append(widthAnchor.constraint(equalToConstant: constant))
        }
        
        widthConstraints.forEach {
            $0.constant = constant
            $0.activate()
        }
    }
}


extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }
    
    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
    
    func setViewBorder(radius: CGFloat = 5, border borderColor: Color, width: CGFloat = 1, bg: Color = .none, alpha: CGFloat = 1) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.color.cgColor
        self.alpha = alpha
        self.layer.backgroundColor = bg.color.cgColor
        
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
}
