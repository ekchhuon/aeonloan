//
//  HomeView.swift
//  AEON Loan
//
//  Created by aeon on 8/25/20.
//

import UIKit

extension HomeView {

    static func instantiate() -> HomeView {
        return HomeView()
    }
}

class HomeView: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.label.text = "Helloooo"
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
