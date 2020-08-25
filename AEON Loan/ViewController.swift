//
//  ViewController.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapped(_ sender: Any) {
        
        let newViewController = HomeView(nibName: "HomeView", bundle: nil)

        // Present View "Modally"
//        self.present(newViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(newViewController, animated: true)
        
        
    }
}

