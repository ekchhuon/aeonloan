//
//  ApplicationAcceptedViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

extension CheckCreditResultViewController {
    static func instantiate(data: CheckCredit?) -> CheckCreditResultViewController {
        let controller = CheckCreditResultViewController()
        controller.dataSource = data
        return controller
    }
}

class CheckCreditResultViewController: BaseViewController {    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitLeLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    var dataSource: CheckCredit?
    var products = [CheckCredit.ProductOffer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Your Credit Result")
        setupTableView()
        applyButton.rounds(radius: 10, background: .white)
        guard let data = dataSource, let products = data.body.data?.productOffer else {
            showMessage(accepted: false)
            return
        }
        showMessage(accepted: true)
        self.products = products
        tableView.reloadData()
    }
    
    fileprivate func showMessage(accepted: Bool) {
        titleLabel.text = accepted ? "Congratulations!".localized : "We apology!".localized
        subtitLeLabel.text = accepted ? "You have got pre-approval with below finance amount:".localized : "You are not meet our criteria to apply loan. Please try again later.".localized
        applyButton.setTitle( accepted ? "Apply Now" : "Home", for: .normal)
    }
    
    func setupTableView(){
        self.tableView.register(nibName: CreditAcceptedTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 45
    }
}

extension CheckCreditResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditAcceptedTableViewCell", for: indexPath) as! CreditAcceptedTableViewCell
        cell.setup(data: products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index:....", indexPath.row)
    }
    
    // MARK: Outlet Action
    @IBAction func applyButtonTapped(_ sender: Any) {
        navigates(to: .applyLoan)
    }
}
