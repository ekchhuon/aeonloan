//
//  UIView + Loading.swift
//  AEON Loan
//
//  Created by aeon on 11/20/20.
//

import UIKit
import MBProgressHUD

import MBProgressHUD
import UIKit

extension UIView {
    @discardableResult
    func showLoadingIndicator(animated: Bool = true) -> MBProgressHUD {
        return MBProgressHUD.showAdded(to: self, animated: animated)
    }
    
    func hideLoadingIndicator(animated: Bool = true) {
        MBProgressHUD.hide(for: self, animated: animated)
    }
    
    func showProgressIndicator(progress: Float,animated: Bool = true) -> MBProgressHUD {
        let indicator = MBProgressHUD.showAdded(to: self, animated: animated)
        indicator.mode = .determinateHorizontalBar
        indicator.contentColor = .brandPurple
        indicator.progress = progress
        indicator.label.text = "Uploading..."
        indicator.label.textColor = .black
        return indicator
    }
    
    // Indicator with option
    @discardableResult
    func showLoadingIndicator(with mode: MBMode = .default,animated: Bool = true) -> MBProgressHUD {
        hideLoadingIndicator()
        let checkmark = UIImage(systemName: "checkmark")?.withColor(.systemGreen)
        let xmark = UIImage(systemName: "xmark")?.withColor(.systemRed)
        let indicator = MBProgressHUD.showAdded(to: self, animated: animated)
        
        switch mode {
        case let .success(label):
            indicator.customView = UIImageView(image: checkmark)
            indicator.mode = .customView
            indicator.label.text = label
            return indicator
        case let .failure(label):
            indicator.customView = UIImageView(image: xmark)
            indicator.mode = .customView
            indicator.label.text = label
            return indicator
            
        case let .textOnly(label):
            indicator.mode = .text
            indicator.label.text = label
            return indicator
        default:
            //indicator.backgroundColor = .brandYellow
            //indicator.contentColor = .red
            //indicator.tintColor = .brandMaginta
            //indicator.isSquare = false
            //indicator.minSize = CGSize(width: 10, height: 10)
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = .medium
            activityIndicator.startAnimating()
            indicator.customView = activityIndicator
            indicator.mode = .customView
            //indicator.label.text = "Loading"
            indicator.graceTime = 0.5
            
            return indicator
        }
    }
    

}

extension UIViewController {
    @discardableResult
    func showLoadingIndicator(animated: Bool = true) -> MBProgressHUD {
        return view.showLoadingIndicator(animated: animated)
    }
    
    func hideLoadingIndicator(animated: Bool = true) {
        view.hideLoadingIndicator(animated: animated)
    }
    @discardableResult
    func showLoadingIndicator(with mode: MBMode = .default, animated: Bool = true) -> MBProgressHUD {
        return view.showLoadingIndicator(with: mode, animated: animated)
    }
    
    @discardableResult
    func showProgressIndicator(progress: Float,animated: Bool = true) -> MBProgressHUD {
        return view.showProgressIndicator(progress: progress, animated: animated)
    }
}

enum MBMode {
    case `default`
    case success(String)
    case failure(String)
    case textOnly(String)
}

