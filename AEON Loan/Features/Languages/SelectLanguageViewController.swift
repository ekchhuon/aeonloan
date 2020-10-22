//
//  SelectLanguageViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import UIKit
import RNCryptor

enum Language: Int {
    case en = 0
    case km = 1
    var index: Int {
        return self.rawValue
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
        
    }
    
    @IBAction func KHSelected(_ sender: Any) {
        select(lang: .km)
    }
    
    @IBAction func ENSelected(_ sender: Any) {
        select(lang: .en)
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        navigates(to: .login)
        /*
        let encrypted = "How are you!".encrypt()
        print("encrypted cipher", encrypted)
        print("decrypted original", encrypted.decrypt())
        */
    }
}

