//
//  NotificationCell.swift
//  AEON Loan
//
//  Created by aeon on 11/23/20.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [icon, title].forEach { $0?.showAnimatedGradientSkeleton() }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideSkeleton() {
        [icon, title].forEach { $0?.hideSkeleton() }
    }
}
