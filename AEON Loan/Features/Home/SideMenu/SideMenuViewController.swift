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
    private var viewModel = SideMenuViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    private var items = ["About Us", "Contact Us", "Change Phone Number", "Change Phone Number", "Change Language"]
    private var icons = ["questionmark.circle", "phone", "phone.badge.plus", "phone.badge.plus", "globe"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.view.backgroundColor = .brandPurple
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.profileImageView.setRounded()
        
        items.append(AuthController.isSignedIn ? "Logout":"Sign In")
        icons.append(AuthController.isSignedIn ? "arrow.backward.square": "arrow.forward.square")
        
        bind()
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.tintColor = .white
        self.view.backgroundColor = .brandPurple
        [welcomeLabel, usernameLabel, userIDLabel].forEach { $0?.textColor = .white }
    }
    /*
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
    */
    
    func navigateToLogin() {
        let login = LoginViewController.instantiate()
        self.view.window?.setRootViewController(login, options: .init(type: .push(subtype: .fromRight)))
    }
    
    private func navigateToWebview(with request: WKRequest) {
        let controller = WKViewController.instantiate(request: request)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - TableView Delegate & Datasource
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.setup(label: items[indexPath.row], icon: icons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected", indexPath.row)
        
        switch indexPath.row {
        case 0:
            navigateToWebview(with: .aboutUs)
        case 1:
            navigateToWebview(with: .contactUs)
        case 4:
            
            //let controller = SettingViewController.instantiate()
            //navigationController?.pushViewController(controller, animated: true)
            
            
//            let controller = LanguageListViewController.instantiate()
//            navigationController?.pushViewController(controller, animated: true)
            
            
//            let controller = LanguageListViewController.instantiate()
//            self.present(controller, animated: true, completion: nil)

            
            let alert = showAlt(title: "Language".localized, message: "Select a Language".localized, actionTitle: "Cancel", style: .actionSheet, actionStyle: .cancel) {
                self.dismiss(animated: true, completion: nil)
            }
            let khAction = UIAlertAction(title: "ភាសាខ្មែរ", style: .default) {_ in
                AppLanguage.set(language: .km)
                self.navigates(to: .home(.fade))
            }
            
            let enAction = UIAlertAction(title: "English", style: .default) { _ in
                print("EN Selected...")
                AppLanguage.set(language: .en)
                self.navigates(to: .home(.fade))
            }
            /*
            let cameraImage = UIImage(systemName: "tray")!
            let cameraImageFill = UIImage(systemName: "tray.fill")!
            
//            khAction.setImage(image: cameraImage)
//            enAction.setImage(image: cameraImageFill)
            khAction.setAlignment(mode: .justified)
            enAction.setAlignment(mode: .justified)
            */
            
            alert.addAction(khAction)
            alert.addAction(enAction)
            
        
        case 5:
            guard AuthController.isSignedIn else {
                navigates(to: .login)
                return
            }
//            let alert = showAlt(title: "Logout".localized, message: "Are you sure you want to logout?".localized, actionTitle: "Cancel", style: .actionSheet)
            let alert = showAlt(title: "Logout".localized, message: "Are you sure you want to logout?".localized, actionTitle: "Cancel".localized, style: .actionSheet, actionStyle: .cancel)
            let okAction = UIAlertAction(title: "Logout".localized, style: .destructive) {_ in
//                self.viewModel.logout { _ in
//                    try? AuthController.signOut()
//                    self.navigates(to: .home(.fade))
//                }
                
                try? AuthController.signOut()
                self.navigates(to: .home(.fade))
            }
            alert.addAction(okAction)
        default:
            break
        }
    }
}


extension UIAlertAction {
    func setImage(image: UIImage) {
        self.setValue(image, forKey: "image")
    }
    
    func setAlignment(mode alignment: CATextLayerAlignmentMode) {
        self.setValue(alignment, forKey: "titleTextAlignment")
    }
}

//class Languages{
//    static func setLanguage(lang: Language) {
//        UserDefaults.standard.set([lang.identifier], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//        Bundle.setLanguage(lang.identifier)
//        Preference.language = lang
//    }
//}
