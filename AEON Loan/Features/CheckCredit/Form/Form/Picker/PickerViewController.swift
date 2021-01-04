//
//  PickerViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import UIKit

extension PickerViewController {
    static func instantiate(_ variable: VariableType, _ pickedItem: String?) -> PickerViewController {
        let controller = PickerViewController()
        controller.variableType = variable
        controller.pickedItem = pickedItem
        return controller
    }
}
class PickerViewController: BaseViewController {
    private let viewModel = CheckCreditPickerViewModel()
    @IBOutlet weak var tableView: UITableView!
    var variableType: VariableType?
    var pickedItem: String?
    var writeBackDelegate: WriteValueBackDelegate?
    private var variables: [Variable.Data]?
    private var selectedVariable: Variable.Data?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
        bind()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // fetch
        guard let variable = variableType else {
            debugPrint("No Variable Code"); return
        }
        viewModel.fetchVariable(with: variable)
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title:"".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        viewModel.response.bind { [weak self] data in
            guard let self = self else { return }
            self.variables = data
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if let delegate = self.writeBackDelegate {
                let data = (selectedVariable, variableType )
                delegate.writeBack(value: data)
            }
        }
    } 
}

extension PickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variables?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
        cell.textLabel?.text = variables?[indexPath.row].titleEn

        if cell.textLabel?.text == pickedItem {
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVariable = variables?[indexPath.row]
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return variableType?.value
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

