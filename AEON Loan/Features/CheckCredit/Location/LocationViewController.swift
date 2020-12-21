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

class LocationViewController: BaseViewController, WriteValueBackDelegate {
    private let viewModel = LocationViewModel()
    
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
        
        self.tableView.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
    
    @IBAction func villageButtonTapped(_ sender: Any) {
        print("Communecode", commune?.code)
        
        guard let code = commune?.code else {
            debugPrint("No location code"); return
        }
        let controller = SubLocationListViewController.instantiate(code: code, for: .village)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
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


