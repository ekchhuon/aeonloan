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
        cellContentView.setBorder(10)
    }
    
    func setupMenu(menu: Menu) {
        self.icon.image = menu.icon
        self.title.text = menu.title
    }
    
    func disableCell(index: Int){
        switch index {
        case 2, 3:
            cellContentView.backgroundColor = .disabled
        default:
            break
        }
    }
}
