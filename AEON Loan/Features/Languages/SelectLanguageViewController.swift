//
//  SelectLanguageViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import UIKit
import RNCryptor

enum Language: Int, Codable {
    case en
    case km
    var identifier: String {
        switch self {
        case .km:
            return "km"
        default:
            return "en"
        }
    }
    
    var index: Int {
        switch self {
        case .en:
            return 0
        default:
            return 1
        }
    }
}

extension SelectLanguageViewController {
    static func instantiate() -> SelectLanguageViewController {
        return SelectLanguageViewController()
    }
}

class SelectLanguageViewController: UIViewController {
    @IBOutlet weak var KHButton: UIButton!
    @IBOutlet weak var ENButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    var selected: Language = .en
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        select(lang: .en)
        continueButton.setBorder()
        continueButton.backgroundColor = .brandPurple
    }
    
    private func select(lang language: Language) {
        let buttons = [ENButton, KHButton]
        buttons.forEach {
            $0?.setBorder(5, border: .gray, width: 1, alpha: 0.5)
            $0?.setTitleColor(.gray, for: .normal)
            $0?.backgroundColor = .white
        }
        
        buttons[language.index]?.backgroundColor = .brandPurple
        buttons[language.index]?.setTitleColor(.white, for: .normal)
        buttons[language.index]?.setBorder()
        
        Preference.language = language
//        Languages(lang: language).change()
        selected = language
    }
    
    @IBAction func KHSelected(_ sender: Any) {
        select(lang: .km)
    }
    
    @IBAction func ENSelected(_ sender: Any) {
        select(lang: .en)
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        // navigates(to: .login)
        /*
        let encrypted = "How are you!".encrypt()
        print("encrypted cipher", encrypted)
        print("decrypted original", encrypted.decrypt())
        */
        
        
        
        
        
        
        
        
        
            // This is done so that network calls now have the Accept-Language as Language.getCurrentLanguage() (Using Alamofire) Check if you can remove these
            UserDefaults.standard.set([selected.identifier], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()

            // Update the language by swaping bundle
            Bundle.setLanguage(selected.identifier)

            // Done to reintantiate the storyboards instantly
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        
        self.navigates(to: .home(.push(subtype: .fromRight)))
    }
}


