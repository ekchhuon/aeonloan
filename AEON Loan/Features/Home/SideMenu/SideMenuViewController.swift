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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    private let items = ["About Us", "Contact Us", "Change Phone Number", "Change Phone Number", "Change Language", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.profileImageView.setRounded()
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
        cell.setup(label: items[indexPath.row].localized)
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
            
            
            let controller = LanguageListViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
            
            
//            let controller = LanguageListViewController.instantiate()
//            self.present(controller, animated: true, completion: nil)
            

            
            /*
            let alert = showAlt(title: "Choose Language", message: "", style: .actionSheet)
            let khAction = UIAlertAction(title: "KH   \(Preference.language == .km ? "✓" : "")  ", style: .default) {_ in
                print("KH Selected...")
                Preference.language = .km
                Languages(lang: .km).change()
                Bundle.setLanguage("km")
                self.tableView.reloadData()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            
            let enAction = UIAlertAction(title: "EN   \(Preference.language == .en ? "✓" : "") ", style: .default) { _ in
                print("EN Selected...")
                Preference.language = .en
                Languages(lang: .en).change()
                Bundle.setLanguage("en")

                self.tableView.reloadData()

                
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                
                
            }
            
            let cameraImage = UIImage(systemName: "tray")!
            let cameraImageFill = UIImage(systemName: "tray.fill")!
            
//            khAction.setImage(image: cameraImage)
//            enAction.setImage(image: cameraImageFill)
            khAction.setAlignment(mode: .justified)
            enAction.setAlignment(mode: .justified)
            
            
            
            alert.addAction(khAction)
            alert.addAction(enAction)
            */
        
        case 5:
            showALertWithOption(title: "Logout", message: "Are you sure you want to logout?", dismissButtonTitle: "Cancel", okButtonTitle: "Logout", style: .actionSheet, dismissActionStyle: .cancel, okActionStyle: .destructive) {
                print("Canceled")
            } okAction: {
                self.navigateToLogin()
            }

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
