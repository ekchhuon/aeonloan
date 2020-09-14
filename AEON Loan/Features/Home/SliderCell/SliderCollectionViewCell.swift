//
//  SliderCollectionViewCell.swift
//  AEON Loan
//
//  Created by aeon on 9/9/20.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sliderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderImage.contentMode = .scaleAspectFill
    }

}
