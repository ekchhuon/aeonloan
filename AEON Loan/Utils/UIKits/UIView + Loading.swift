//
//  UIView + Loading.swift
//  AEON Loan
//
//  Created by aeon on 11/20/20.
//

import UIKit
import MBProgressHUD
import UIKit


enum IndicatorDisplayStyle{
    case `default`
    case whiteBackground
}
extension UIView {
    
    // convenience
    @discardableResult
    func showIndicator(_ shown: Bool, style: IndicatorDisplayStyle = .default, animated: Bool = true) -> MBProgressHUD {
        
        if shown {
            return showLoadingIndicator(animated: animated, style: style)
        } else {
            hideLoadingIndicator(animated: animated)
            return MBProgressHUD()
        }
    }
    
    @discardableResult
    func showLoadingIndicator(animated: Bool = true, style: IndicatorDisplayStyle = .default) -> MBProgressHUD {
        let indicator = MBProgressHUD.showAdded(to: self, animated: animated)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        indicator.customView = activityIndicator
        indicator.mode = .customView
        indicator.backgroundColor = style == .whiteBackground ? .white : .none
        indicator.bezelView.style = style == .whiteBackground ? .solidColor : .blur
        return indicator
    }
    
    func hideLoadingIndicator(animated: Bool = true){
        MBProgressHUD.hide(for: self, animated: animated)
    }
}

extension UIViewController {
    // convenience
    @discardableResult
    func showIndicator(_ show: Bool, style: IndicatorDisplayStyle = .default, animated: Bool = true) -> MBProgressHUD {
        
        if show {
            return showLoadingIndicator(animated: animated, style: style)
        } else {
            hideLoadingIndicator(animated: animated)
            return MBProgressHUD()
        }
    }
    @discardableResult
    func showLoadingIndicator(animated: Bool = true, style: IndicatorDisplayStyle = .default) -> MBProgressHUD {
        return view.showLoadingIndicator(animated: animated, style: style)
    }
    
    func hideLoadingIndicator(animated: Bool = true) {
        view.hideLoadingIndicator(animated: animated)
    }
}

