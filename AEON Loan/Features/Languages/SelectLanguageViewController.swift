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
    case none
    var name: String {
        switch self {
        case .km: return "ភាសារខ្មែរ"
        case .en: return "English"
        default: return "N/A"
        }
    }
    var identifier: String {
        switch self {
        case .km: return "km"
        case .en: return "en"
        default: return "N/A"
        }
    }
    
    var code: Int{
        switch self {
        case .km: return 1
        case .en: return 2
        default: return 0
        }
    }
    
    var index: Int {
        switch self {
        case .en: return 0
        case .km: return 1
        default: return 3
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
        
         let encrypted = "How are you!".encrypt()
         print("encrypted cipher", encrypted)
         print("decrypted original", encrypted.decrypt())
         
        
//        AppLanguage.set(language: selected)
//        self.navigates(to: .home(.push(subtype: .fromRight)))
    }
}


