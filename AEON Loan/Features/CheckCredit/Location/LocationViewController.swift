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
    static func instantiate(data: Applicant, loan: ApplyLoan?) -> LocationViewController {
        let controller = LocationViewController()
        controller.applicant = data
        controller.loan = loan
        return controller
    }
}

class LocationViewController: BaseViewController, UITextFieldDelegate, WriteValueBackDelegate {
    private let viewModel = LocationViewModel()
    private let creditPickerViewModel = CheckCreditPickerViewModel()
    private let loanViewModel = ApplyLoanViewModel()
    private var applicant = Applicant()
    private var loan: ApplyLoan?
    
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var communeTextField: UITextField!
    @IBOutlet weak var villageTextField: UITextField!
    @IBOutlet weak var livingPeriodTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var locationLabels: [UILabel]!
    
    var livings: [Variable.Data]?
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
        bind()
        creditPickerViewModel.fetchVariable(with: .livingPeriod)
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        // check credit
        creditPickerViewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        creditPickerViewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        creditPickerViewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        creditPickerViewModel.response.bind { [weak self] data in
            guard let self = self else { return }
            self.livings = data
            self.pickerView.reloadAllComponents()
        }
        
        // loan
        loanViewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        loanViewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        loanViewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        loanViewModel.response.bind { [weak self] data in
            guard let self = self else { return }

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
        guard let code = commune?.code else {
            debugPrint("No location code"); return
        }
        let controller = LocationPicker2ViewController.instantiate(code: code, for: .village, pickedItem: village?.name)
        controller.writeBackDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        print(loan, applicant)
        validate { [self] applicant in
            viewModel.submit(data: applicant)
            guard let loan = loan else { return }
            loanViewModel.submit(data: loan)// mock
        }
    }
    
    private func validate(completion: @escaping (_ data: Applicant) -> Void) {
        do {
            _ = try provinceTextField.validatedText(type: .requiredField(field: LocationType.province.value))
            _ = try districtTextField.validatedText(type: .requiredField(field: LocationType.district.value))
            _ = try communeTextField.validatedText(type: .requiredField(field: LocationType.commune.value))
            _ = try villageTextField.validatedText(type: .requiredField(field: LocationType.village.value))
            let livingPeriod = try livingPeriodTextField.validatedText(type: .other(message: "Living Period".localized))
            
            applicant.provinceCode = province?.code ?? ""
            applicant.districtCode = district?.code ?? ""
            applicant.communeCode = commune?.code ?? ""
            applicant.villageCode = village?.code ?? ""
            applicant.livingPeriod = livingPeriod
            
            completion(applicant)
            //navigates(to: .checkCredit(.location(applicant)))
        } catch (let error) {
            let error = (error as! ValidationError).message
            showAlt(title: error , message: "", style: .alert)
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
        return livings?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = Preference.language == .km ? livings?[row].titleKh : livings?[row].titleEn
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        livingPeriodTextField.text = livings?[row].titleKh ?? livings?[row].titleEn ?? ""
        selectedLivingPeriod = Preference.language == .km ? livings?[row].titleKh : livings?[row].titleEn
    }

}
