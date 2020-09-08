//
//  NavigationController.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import UIKit

class NavigationController: UINavigationController {
    var statusBarStyle: UIStatusBarStyle = .lightContent

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

class MainNavigationController: NavigationController {
    init(with rootViewController: UIViewController) {
        super.init(navigationBarClass: BlueNavigationBar.self, toolbarClass: nil)
        pushViewController(rootViewController, animated: false)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
//        viewController.navigationItem.tit
        
        viewController.navigationItem.titleView = UIView().apply {
            let imageView = UIImageView(image: UIImage(named: "banner"))
            imageView.contentMode = .scaleAspectFit
            $0.addSubview(imageView)
            imageView.pinInSuperview(to: .all, with: .all(8))
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension NavigationController {
    static func main(with rootController: UIViewController) -> UINavigationController {
        let navigationController = NavigationController(navigationBarClass: BlueNavigationBar.self, toolbarClass: nil)
        navigationController.pushViewController(rootController, animated: false)
        return navigationController
    }

    static func dark(with rootController: UIViewController) -> UINavigationController {
        let navigationController = NavigationController(navigationBarClass: DarkNavigationBar.self, toolbarClass: nil)
        navigationController.pushViewController(rootController, animated: false)
        return navigationController
    }

    static func blue(with rootController: UIViewController) -> UINavigationController {
        let navigationController = NavigationController(navigationBarClass: BlueNavigationBar.self, toolbarClass: nil)
        navigationController.pushViewController(rootController, animated: false)
        return navigationController
    }

    static func white(with rootController: UIViewController) -> UINavigationController {
        let navigationController = NavigationController(navigationBarClass: WhiteNavigationBar.self, toolbarClass: nil)
        navigationController.statusBarStyle = .default
        navigationController.pushViewController(rootController, animated: false)
        return navigationController
    }
}


extension NSObjectProtocol {

    @discardableResult
    func apply(fun: (Self) -> Void) -> Self {
        fun(self)
        return self
    }
}
