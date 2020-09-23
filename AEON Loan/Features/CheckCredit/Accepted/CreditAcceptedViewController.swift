//
//  ApplicationAcceptedViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/22/20.
//

import UIKit

extension CreditAcceptedViewController {
    static func instantiate() -> CreditAcceptedViewController {
        return CreditAcceptedViewController()
    }
}

class CreditAcceptedViewController: BaseViewController {
    private let viewModel = CreditAcceptedViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitLeLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    var credits = [Credit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        bind()
    }
    
    private func bind(){
        viewModel.credits.bind { [weak self] (credits) in
            guard let self = self, let credits = credits else { return }
            self.credits = credits
            self.tableView.reloadData()
        }
    }
    
    func setupView() {
        // setup(title: NSLocalizedString("Apply Loan/Installment", comment: ""))
        applyButton.rounds(radius: 10, background: .white)
        applyButton.setTitle(NSLocalizedString("Apply Now", comment: ""), for: .normal)
        titleLabel.text = NSLocalizedString("Congratulations!!!", comment: "")
        subtitLeLabel.text = NSLocalizedString("You meet our criterial. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam", comment: "")
    }
    
    func setupTableView(){
        self.tableView.register(nibName: CreditAcceptedTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 45
    }
    
}

extension CreditAcceptedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditAcceptedTableViewCell", for: indexPath) as! CreditAcceptedTableViewCell
        cell.setup(data: credits[indexPath.row])
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
