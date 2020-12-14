//
//  SideMenuTableViewCell.swift
//  AEON Loan
//
//  Created by aeon on 11/3/20.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .brandPurple
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(label text: String, icon name: String) {
        self.itemLabel.text = "\(text)".localized
        self.itemIcon.image = UIImage(systemName: name)?.withRenderingMode(.alwaysOriginal).withColor(.white)
    }
    
}
