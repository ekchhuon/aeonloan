//
//  File.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import UIKit

extension UIWindow {
    func setRootViewController(_ controller: UIViewController, options: CATransition.Options = .default) {
        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        self.makeKeyAndVisible()
    }
}
