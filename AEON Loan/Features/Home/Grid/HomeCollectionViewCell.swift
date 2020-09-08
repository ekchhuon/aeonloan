//
//  HomeCollectionViewCell.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellContentView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellContentView.setViewBorder(radius: 10, border: .purple, width: 1, bg: .none, alpha: 1)
    }

}
