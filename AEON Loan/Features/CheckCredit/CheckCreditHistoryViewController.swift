//
//  CheckCreditHistoryViewController.swift
//  AEON Loan
//
//  Created by aeon on 11/30/20.
//

import UIKit

extension CheckCreditHistoryViewController {
    static func instantiate(data: [CheckCredit.ProductOffer]?) -> CheckCreditHistoryViewController {
        let controller = CheckCreditHistoryViewController()
        controller.products = data
        return controller
    }
}

class CheckCreditHistoryViewController: BaseViewController {
    private let viewModel = ApplyLoanViewModel()    
    @IBOutlet weak var applyLoanButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var products: [CheckCredit.ProductOffer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle("Credit History".localized)
        self.tableView.register(nibName: OffersTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = 50
        self.tableView.separatorInset = .zero
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = .brandPurple
        applyLoanButton.rounds(radius: 10)
//        bind()
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            guard msg.contains("No data found") else {
                self.showAlert(title: "".localized ,message: msg)
                return
            }
            self.navigates(to: .checkCredit(.form(nil)))
        }
        
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        viewModel.products.bind { [weak self] (products) in
            guard let self = self else { return }
            self.products = products
            self.tableView.reloadData()
        }
    }
    
    @IBAction func newButtonTapped(_ sender: Any) {
        navigates(to: .checkCredit(.form(nil)))
    }
    
    @IBAction func applyLoanButtonTapped(_ sender: Any) {
        navigates(to: .applyLoan)
    }
    
}

extension CheckCreditHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffersTableViewCell", for: indexPath) as! OffersTableViewCell
        
        cell.backgroundColor = .brandPurple
        
        cell.productLabel.text = "\(indexPath.row + 1). \(products?[indexPath.row].product ?? "Not Found")"
        cell.amountLabel.text = "up to".localized + ": " + "USD" + " " + "\(products?[indexPath.row].fa ?? 0)".asCurrency
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ndexPath.row", indexPath.row)
    }
}
