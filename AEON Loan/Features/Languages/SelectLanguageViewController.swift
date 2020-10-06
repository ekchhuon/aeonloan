//
//  SelectLanguageViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/7/20.
//

import UIKit

enum Language {
    case EN
    case KH
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
    
    var defaultLang: Language = .EN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        select(defaultLang)
        continueButton.setButtonBorder(title: .none, border: .none, bg: .purple)
    }
    
    private func select(_ language: Language) {
        KHButton.setButtonBorder(border: .gray, width: 1, alpha: 0.8)
        ENButton.setButtonBorder(border: .gray, width: 1, alpha: 0.8)
        defaultLang = language
        if language == .EN {
            ENButton.setButtonBorder(title: .purple, border: .purple, width: 1)
        } else {
            KHButton.setButtonBorder(title: .purple, border: .purple, width: 1)
        }
    }
    
    @IBAction func KHSelected(_ sender: Any) {
        select(.KH)
    }
    
    @IBAction func ENSelected(_ sender: Any) {
        select(.EN)
    }

    @IBAction func selectButtonTapped(_ sender: Any) {
        print(defaultLang)
        navigates(to: .home(.push(subtype: .fromRight)))
    }
    
}





