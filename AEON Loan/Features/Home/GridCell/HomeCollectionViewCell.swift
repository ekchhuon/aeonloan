//
//  HomeCollectionViewCell.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        cellContentView.rounds(10)
    }
    
    func setupMenu(menu: Menu) {
        self.icon.image = menu.icon
        self.title.text = menu.title
    }
}
