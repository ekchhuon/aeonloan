//
//  LocationTableViewCell.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var autoDebitFeeLabel: UILabel!
    @IBOutlet weak var counterFeeLabel: UILabel!
    @IBOutlet weak var mobileFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupData(channel: Channel) {
        self.nameLabel.text = channel.name
        self.accountLabel.text = "  Account Number: " + channel.account
        self.autoDebitFeeLabel.text = "  Auto Debit: " + "\(channel.isAutoDebit)"
        self.counterFeeLabel.text = "  Pay At Counter: " + channel.counterFee
        self.mobileFeeLabel.text = "  Pay via Mobile App: " + channel.mobileFee
    }
    
}
