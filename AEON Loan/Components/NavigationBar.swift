//
//  NavigationBar.swift
//  AEON Loan
//
//  Created by aeon on 8/26/20.
//

import UIKit

class NavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

extension NavigationBar {
    private func setup() {
        setupAppearance()
    }

    @objc func setupAppearance() {}
}

class BlueNavigationBar: NavigationBar {
    override func setupAppearance() {
        super.setupAppearance()
        tintColor = .white
        self.isTranslucent = false
        barTintColor = .brandPurple
        
//        setBackgroundImage(UIImage(named: "banner"), for: .default)
//        titleTextAttributes = [.font: FontFamily.Muli.bold.font(size: 17), .foregroundColor: Asset.Colors.white.color]
    }
}

class DarkNavigationBar: NavigationBar {
    override func setupAppearance() {
        super.setupAppearance()
        tintColor = .white
//        setBackgroundImage(Asset.Images.Background.Navigation.dark.image, for: .default)
    }
}

class WhiteNavigationBar: NavigationBar {
    override func setupAppearance() {
        super.setupAppearance()
        barTintColor = .white
        tintColor = .blue
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
    }
}
