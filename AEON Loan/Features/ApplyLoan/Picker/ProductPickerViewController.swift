//
//  ProductPickerViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/30/20.
//

import UIKit

//class ProductPickerViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

extension ProductPickerViewController {
    static func instantiate(_ data: [CheckCredit.ProductOffer], _ pickedItem: String) -> ProductPickerViewController {
        let controller = ProductPickerViewController()
        controller.pickedItem = pickedItem
        controller.products = data
        return controller
    }
}

class ProductPickerViewController: BaseViewController {
    private let viewModel = ApplyLoanViewModel()
    @IBOutlet weak var tableView: UITableView!
    var pickedItem: String?
    var writeBackDelegate: WriteValueBackDelegate?
    var products: [CheckCredit.ProductOffer]?
    var selectedItem: CheckCredit.ProductOffer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(nibName: ProductPickerCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        self.bind()
//        self.viewModel.fetchCheckCreditStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if let delegate = self.writeBackDelegate {
                delegate.writeBack(value: selectedItem)
            }
        }
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Product Type".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Product Type".localized, message: err.localized)
        }
        viewModel.response.bind { [weak self] data in
            guard let self = self else { return }
            self.products = data?.body.data?.productOffer
            self.tableView.reloadData()
        }
    }
}

extension ProductPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductPickerCell", for: indexPath) as! ProductPickerCell
        cell.textLabel?.text = products?[indexPath.row].product
        
        if cell.textLabel?.text == pickedItem {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = products?[indexPath.row]
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Product Type"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
