//
//  LanguageListCell.swift
//  AEON Loan
//
//  Created by aeon on 11/25/20.
//

import UIKit

class LanguageListCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        /*
        self.contentView.backgroundColor = .brandPurple
        self.tintColor = .white
        self.textLabel?.textColor = .white
        self.backgroundColor = .brandPurple
        */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
}
