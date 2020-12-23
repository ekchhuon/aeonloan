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
    
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var communeTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var livingPeriodTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var locationLabels: [UILabel]!
    
    let livings = ["1-6M", "6-12M", "12-24M", "24-60M"]
    let pickerView = UIPickerView()
    var province: Location.Data?
    var district: Location.Data?
    var commune: Location.Data?
    var village: Location.Data?
    var selectedLivingPeriod: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livingPeriodTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        livingPeriodTextField.delegate = self
        viewModel.locationCode.bind { code in
            self.provinceTextField.text = code
        }
        submitButton.rounds(radius: 10)
        submitButton.backgroundColor = .brandPurple
        updateLocationLabel()
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
    
    private func updateTextField() {
        provinceTextField.text = province?.name
        districtTextField.text = district?.name
        communeTextField.text = commune?.name
        villageTextField.text = village?.name
        
        updateLocationLabel()
    }
    
    private func updateLocationLabel() {
        //[0] = district
        locationLabels[0].textColor = provinceTextField.text!.isEmpty ? .lightGray  : nil
        locationLabels[1].textColor = districtTextField.text!.isEmpty ? .lightGray  : nil
        locationLabels[2].textColor = communeTextField.text!.isEmpty ? .lightGray  : nil
    }
    
    @IBAction func provinceButtonTapped(_ sender: Any) {
        let controller = LocationPicker1ViewController.instantiate(code: "", for: .province, pickedItem: province?.name)
        controller.writeBackDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func districtButtonTapped(_ sender: Any) {
        print(province?.code)
        guard let code = province?.code else {
            debugPrint("No location code"); return
        }
        let controller = LocationPicker2ViewController.instantiate(code: code, for: .district, pickedItem: district?.name)        
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func communeButtonTapped(_ sender: Any) {
        guard let code = district?.code else {
            debugPrint("No location code"); return
        }
        let controller = LocationPicker2ViewController.instantiate(code: code, for: .commune, pickedItem: commune?.name)
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
        let controller = LocationPicker2ViewController.instantiate(code: code, for: .village, pickedItem: village?.name)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
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


// MARK: PickerView Delegate & DataSource
extension LocationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.text!.isEmpty else {return}
        pickerView.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(pickerView, didSelectRow: 0, inComponent: 0)
    }
    
//    // select first row
//    private func selectFirstRow(_ textField: UITextField,  _ picker: UIPickerView){
//        guard textField.text!.isEmpty else {return}
//        picker.selectRow(0, inComponent: 0, animated: true)
//        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return livings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return livings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        livingPeriodTextField.text = livings[row]
        selectedLivingPeriod = livings[row]
    }

}
