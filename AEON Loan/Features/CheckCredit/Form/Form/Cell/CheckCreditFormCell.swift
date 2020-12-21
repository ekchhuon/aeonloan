//
//  CheckCreditFormCell.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import UIKit

class CheckCreditFormCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
