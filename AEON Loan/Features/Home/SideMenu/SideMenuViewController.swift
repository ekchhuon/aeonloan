//
//  SideMenuViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/9/20.
//

import UIKit

extension SideMenuViewController {
    static func instantiate() -> SideMenuViewController {
        return SideMenuViewController()
    }
}

class SideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        self.navigationController?.navigationBar.tintColor = .white
    }

    private func setupNavigationBar() {
        let usernameButton : UIButton = UIButton.init(type: .custom)
        usernameButton.setTitle("Andrew", for: .normal)
        usernameButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        usernameButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let usernameBtn = UIBarButtonItem(customView: usernameButton)
        
        let profileView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40)) // Add your frames
        let profileImageView = UIImageView(image: UIImage(named: "sample_user")) // Give your image name
        profileImageView.frame = profileView.bounds
        profileView.addSubview(profileImageView)
        let profile = UIBarButtonItem(customView: profileView)
        
        // spacer
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
          space.width = 15

        navigationItem.leftBarButtonItems = [profile, space, usernameBtn]
    }

    @objc
    func handleClick(){
//        let login = LoginViewController.instantiate()
//        navigationController?.pushViewController(login, animated: true)
    }
}
