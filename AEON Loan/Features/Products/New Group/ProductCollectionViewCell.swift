//
//  ProductCollectionViewCell.swift
//  AEON Loan
//
//  Created by aeon on 11/27/20.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(data: Menu) {
        self.productImageView.image = data.icon
        self.productTitle.text = data.title
    }
}
