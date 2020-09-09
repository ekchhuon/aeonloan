//
//  SliderDetailViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/9/20.
//

import UIKit

extension SliderDetailViewController {
    static func instantiate(index:IndexPath, item: String) -> SliderDetailViewController {
        let controller = SliderDetailViewController()
        controller.item = item
        controller.indexPath = index
        return controller
    }
}
class SliderDetailViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var item: String = ""
    var indexPath: IndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = item
        
    }
}
