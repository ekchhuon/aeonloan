//
//  PickerTableViewCell.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import UIKit

class PickerTableViewCell: UITableViewCell {

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
