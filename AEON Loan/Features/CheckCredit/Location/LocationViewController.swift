//
//  LocationViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/16/20.
//

import UIKit

protocol WriteValueBackDelegate {
    func writeBack(value: Any?)
}

extension LocationViewController {
    static func instantiate() -> LocationViewController {
        return LocationViewController()
    }
}

class LocationViewController: BaseViewController, UITextFieldDelegate, WriteValueBackDelegate {
    private let viewModel = LocationViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var communeTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var province: Location.Data?
    var district: Location.Data?
    var commune: Location.Data?
    var village: Location.Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "LocationListTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationListTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.isHidden = true
        
        //cell.textField.text = "Hellloooo"
        
        viewModel.locationCode.bind { code in
            self.provinceTextField.text = code
        }
    }
    
    func writeBack(value: Any?) {
        if let (location,type) = value as? (Location.Data, LocationType) {
            switch type {
            case .province:
                province = location
                district = nil
                commune = nil
                village = nil
                self.updateTextField()
            case .district:
                district = location
                commune = nil
                village = nil
                self.updateTextField()
            case .commune:
                commune = location
                village = nil
                self.updateTextField()
            case .village:
                village = location
                self.updateTextField()
            }   
        }
    }
    
    func updateTextField() {
        provinceTextField.text = province?.name
        districtTextField.text = district?.name
        communeTextField.text = commune?.name
        villageTextField.text = village?.name
    }
    
    @IBAction func provinceButtonTapped(_ sender: Any) {
        let controller = LocationListViewController.instantiate(code: "", for: .province)
        controller.writeBackDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func districtButtonTapped(_ sender: Any) {
        print(province?.code)
        guard let code = province?.code else {
            debugPrint("No location code"); return
        }
        let controller = SubLocationListViewController.instantiate(code: code, for: .district)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func communeButtonTapped(_ sender: Any) {
        guard let code = district?.code else {
            debugPrint("No location code"); return
        }
        let controller = SubLocationListViewController.instantiate(code: code, for: .commune)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func ButtonTapped(_ sender: Any) {
    }
    
    @IBAction func villageButtonTapped(_ sender: Any) {
        print("Communecode", commune?.code)
        
        guard let code = commune?.code else {
            debugPrint("No location code"); return
        }
        let controller = SubLocationListViewController.instantiate(code: code, for: .village)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getCell(for field: TextFieldData) -> CheckCreditFormCell {
        return tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as! CheckCreditFormCell
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        getCell(for: .nameTextField).textField.text = "Helloo"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .allEvents)
    }
    
    @objc func valueChanged(_ textField: UITextField){
        
        switch textField.tag {
        case TextFieldData.nameTextField.rawValue:
            print(textField.text)

        default:
            break
        }
    }
}

enum LocationType {
    case province, district, commune, village
    var value: String {
        switch self {
        case .province: return "Province".localized
        case .district: return "District".localized
        case .commune: return "Commune".localized
        case .village: return "Village".localized
        }
    }
}


extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationListTableViewCell", for: indexPath) as! LocationListTableViewCell
        let fieldDatas = TextFieldData.allCases[indexPath.row]
        cell.textField.delegate = self
        cell.textField.placeholder = fieldDatas.placeholder
        cell.textField.tag = indexPath.row
        cell.imageView?.image = fieldDatas.icon?.withColor(.lightGray)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
