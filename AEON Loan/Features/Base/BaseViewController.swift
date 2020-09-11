//
//  BaseViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/11/20.
//

import UIKit
import SideMenu

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setupAppearance()
    }
    
    func setup(title: String = "") {
        self.navigationItem.title = title
        
        // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "sdfsadsdf", style: .plain, target: nil, action: nil)
    }
    
     private func setupNavigationBar() {
        let bannerIcon = UIImage(named: "banner")?.withRenderingMode(.alwaysOriginal)
        let notificationIcon = UIImage(named: "notification")?.withRenderingMode(.alwaysTemplate)
        let menuIcon = UIImage(named: "hamburger_icon")?.withRenderingMode(.alwaysTemplate)
        let userIcon = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        
        // let banner = UIBarButtonItem( image: bannerIcon, style: .plain, target: self, action: #selector(openSearch))
        
        let bannerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 256.55, height: 30)) // Add your frames
        let bannerImageView = UIImageView(image: bannerIcon) // Give your image name
        bannerImageView.frame = bannerView.bounds
        bannerView.addSubview(bannerImageView)
        let banner = UIBarButtonItem(customView: bannerView)
        
        let notificationButton : UIButton = UIButton.init(type: .custom)
        notificationButton.setImage(notificationIcon, for: .normal)
        notificationButton.addTarget(self, action: #selector(navigateToNotification), for: .touchUpInside)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let notification = UIBarButtonItem(customView: notificationButton)
        
        let menuButton : UIButton = UIButton.init(type: .custom)
        menuButton.setImage(menuIcon, for: .normal)
        menuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let menu = UIBarButtonItem(customView: menuButton)
        
        let userButton : UIButton = UIButton.init(type: .custom)
        userButton.setImage(userIcon, for: .normal)
        userButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        userButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let user = UIBarButtonItem(customView: userButton)
        
        navigationItem.setRightBarButtonItems([menu, notification, user], animated: false)
        navigationItem.leftBarButtonItems = [banner]
    }
    
    private func sideMenuSetting() -> SideMenuSettings {
        var presentation: SideMenuPresentationStyle = SideMenuPresentationStyle()
        presentation = .menuSlideIn
        presentation.menuStartAlpha = 1
        presentation.menuScaleFactor = 1
        presentation.onTopShadowOpacity = 0
        presentation.presentingEndAlpha = 0.5 // overlay::alpha
        presentation.presentingScaleFactor = 1
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentation
        settings.menuWidth = UIScreen.main.bounds.width/1.5
        settings.blurEffectStyle = .none
        settings.statusBarEndAlpha = 0
        settings.presentDuration = 0.5
        
        return settings
    }

    @objc func openSearch() {
        print("search")
    }
    
    @objc
    private func handleClick(){
        let login = LoginViewController.instantiate()
        navigationController?.pushViewController(login, animated: true)
    }
    
    @objc
    private func navigateToNotification() {
        let notification = NotificationViewController.instantiate()
        navigationController?.pushViewController(notification, animated: true)
    }
    
    @objc
    private func showSideMenu() {
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController.instantiate())
        menu.leftSide = false
        menu.navigationBar.barTintColor = .brandPurple
        menu.settings = sideMenuSetting()
        present(menu, animated: true, completion: nil)
    }
}



