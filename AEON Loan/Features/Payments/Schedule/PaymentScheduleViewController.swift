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
        self.setTitle("Payment Schedule".localized)
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupView()
        bind()
        print("tableView.rowHeight",tableView.rowHeight)
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Login".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Login".localized, message: err.localized)
        }
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
        navigates(to: .payment(.scheduleDetailed(agreements[indexPath.row])))
    }
}
