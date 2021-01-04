//
//  ProductPickerCell.swift
//  AEON Loan
//
//  Created by aeon on 12/30/20.
//

import UIKit

class ProductPickerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
}
