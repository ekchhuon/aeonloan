//
//  ProductCell.swift
//  AEON Loan
//
//  Created by aeon on 11/27/20.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.setBorder(10)
//        self.overlayView.setGradientBackground(colorTop: .clear, colorBottom: .blue)
//        selfove.setGradientBackground(colorTop: .clear, colorBottom: Colors.darkGrey)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
////        bounds = UIEdgeInsetsInsetRect(bounds, padding)
//        bounds = bounds.inset(by: padding)
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: Menu) {
        productImageView.image = data.icon
        productTitleLabel.text = data.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15))
    }
    

    
}


extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

        layer.insertSublayer(gradientLayer, at: 0)
}
}
