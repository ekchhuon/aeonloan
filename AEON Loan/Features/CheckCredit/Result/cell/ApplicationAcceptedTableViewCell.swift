//
//  ApplicationAcceptedTableViewCell.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

class CreditAcceptedTableViewCell: UITableViewCell {
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: CheckCredit.ProductOffer) {
        self.product.text = data.product
        self.amount.text = ": \("USD".localized)\(data.fa)"
    }
}
