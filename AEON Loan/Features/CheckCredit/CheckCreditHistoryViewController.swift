//
//  CheckCreditHistoryViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/30/20.
//

import UIKit

extension CheckCreditHistoryViewController {
    static func instantiate() -> CheckCreditHistoryViewController {
        return CheckCreditHistoryViewController()
    }
}

class CheckCreditHistoryViewController: UIViewController {

    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var createNewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.rounds(radius: 10, border: .brandPurple, width: 1)
        
        createNewButton.rounds(radius: 10, background: .brandPurple)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    @IBAction func createNew(_ sender: Any) {
        //navigates(to: .checkCredit(.form))//
        
        let controller = CheckCreditFormViewController.instantiate(item: "")
        navigationController?.pushViewController(controller, animated: true)
        
        
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


