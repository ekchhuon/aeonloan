//
//  PaymentScheduleViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit

extension PaymentScheduleViewController {
    static func instantiate() -> PaymentScheduleViewController {
        return PaymentScheduleViewController()
    }
}

class PaymentScheduleViewController: BaseViewController {
    private let viewModel = PaymentScheduleViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let agreements = ["000000001", "000000002", "000000003", "000000004"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(title: NSLocalizedString("Payment Schedule", comment: ""))
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupView()
    }
    
    private func setupView() {
        titleLabel.text = NSLocalizedString("Download your payment schedule Click on aggreement number bellow:", comment: "")
    }
}

extension PaymentScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.agreementNumber.text = "\(indexPath.row + 1). \(agreements[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PaymentDetailViewController.instantiate(item: agreements[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
