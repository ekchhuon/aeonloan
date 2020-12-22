//
//  CheckCreditFormViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import UIKit

extension CheckCreditFormViewController {
    static func instantiate(item: String) -> CheckCreditFormViewController {
        let controller = CheckCreditFormViewController()
        controller.item = item
        return controller
    }
}

class CheckCreditFormViewController: BaseViewController, UITextFieldDelegate, WriteValueBackDelegate {
    private let viewModel = CheckCreditFormViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deneButton: UIButton!
    private let datePicker = UIDatePicker()
    private let workingPeriodPickerView = UIPickerView()
    let workings = ["1-6M", "6-12M", "12-24M", "24-60M"]
    let livings = ["1-6M", "6-12M", "12-24M", "24-60M"]
    
    var item = ""
    var credit = CheckCredit()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CheckCreditFormCell", bundle: nil), forCellReuseIdentifier: "CheckCreditFormCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.workingPeriodPickerView.delegate = self
        setupDatePicker()

        setupKeyboard(.numberPad, for: .incomeTextField)
        setupKeyboard(.numberPad, for: .aeonLoanRepaymentTextField)
        setupKeyboard(.numberPad, for: .otherLoanRepaymentTextField)
        
        let workingPeriodCell = getCell(for: .workingPeriodTextField)
        workingPeriodCell.textField.inputView = workingPeriodPickerView
        
        deneButton.rounds(radius: 10)
        deneButton.backgroundColor = .brandPurple
        
        //viewModel.filter()
    }
    
    func writeBack(value: Any?) {
        if let (value, variable) = value as? (Variable.Data, VariableType) {
            switch variable {
            case .occupation:
                let row = TextFieldData.occupationTextField.rawValue
                updateTextFieldForRow(at: row , value: value)
                credit.occupation = value.titleEn
            case .maritalStatus:
                let row = TextFieldData.maritalStatusTextField.rawValue
                updateTextFieldForRow(at: row , value: value)
                credit.maritalStatus = value.titleEn
            case .gender:
                let row = TextFieldData.genderTextField.rawValue
                updateTextFieldForRow(at: row , value: value)
                credit.gender = value.titleEn
            case .education:
                let row = TextFieldData.educationTextField.rawValue
                updateTextFieldForRow(at: row , value: value)
                credit.education = value.titleEn
            case .houseType:
                let row = TextFieldData.housingTypeTextField.rawValue
                updateTextFieldForRow(at: row , value: value)
                credit.housingType = value.titleEn
            }
        }
    }
    
    // assign writeback value to textfield
    private func updateTextFieldForRow(at row: Int, value: Variable.Data) {
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! CheckCreditFormCell
        cell.textField.text = value.titleEn // Preference.language == .en ? value.titleEn : value.titleKh
    }
    
    private func setupKeyboard(_ keyboard: UIKeyboardType, for textfield: TextFieldData ) {
        getCell(for: textfield).textField.keyboardType = keyboard
    }
}

// MARK: - Table Delegate & Datasource
extension CheckCreditFormViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TextFieldData.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCreditFormCell", for: indexPath) as! CheckCreditFormCell
        
        let fieldDatas = TextFieldData.allCases[indexPath.row]
        cell.textField.delegate = self
        cell.textField.placeholder = fieldDatas.placeholder
        cell.textField.tag = indexPath.row
        cell.imageView?.image = fieldDatas.icon?.withColor(.lightGray)
        
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(systemName: "questionmark.circle")?.withRenderingMode(.alwaysOriginal).withColor(.lightGray), for: .normal)
        infoButton.sizeToFit()
        
        // Accessory Item Acction
        switch fieldDatas {
        case .occupationTextField, .housingTypeTextField, .educationTextField, .maritalStatusTextField, .genderTextField :
            cell.textField.isUserInteractionEnabled = false
            cell.accessoryType = .disclosureIndicator
        case .aeonLoanRepaymentTextField:
            infoButton.addTarget(self, action: #selector(aeonRepaymentQuestionMarkTapped), for: .touchUpInside)
            cell.accessoryView = infoButton
        
        case .otherLoanRepaymentTextField:
            infoButton.addTarget(self, action: #selector(otherLoanQuestionMarkTapped), for: .touchUpInside)
            cell.accessoryView = infoButton
        case .dobTextField:
            infoButton.addTarget(self, action: #selector(dobQuestionMarkTapped), for: .touchUpInside)
            cell.accessoryView = infoButton
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch TextFieldData.allCases[indexPath.row] {
        case .occupationTextField:
            let controller = PickerViewController.instantiate(.occupation, credit.occupation)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .educationTextField:
            let controller = PickerViewController.instantiate(.education, credit.education)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .maritalStatusTextField:
            let controller = PickerViewController.instantiate(.maritalStatus, credit.maritalStatus)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .genderTextField:
            let controller = PickerViewController.instantiate(.gender, credit.gender)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .housingTypeTextField:
            let controller = PickerViewController.instantiate(.houseType, credit.housingType)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        default:
            break
        }
        
    }
    
    @objc func aeonRepaymentQuestionMarkTapped() {
        let alert = showAlt(title: "Aeon Repayment".localized, message: "Lorem ipsum dolor sit amet".localized, style: .alert)
        let okAction = UIAlertAction(title: "Calculate", style: .default) {_ in
            self.navigates(to: .calculator)
        }
        alert.addAction(okAction)
    }
    
    @objc func otherLoanQuestionMarkTapped() {
        showAlt(title: "Other Loan Repayment".localized, message: "Lorem ipsum dolor sit amet".localized, style: .alert)
    }
    
    @objc func dobQuestionMarkTapped() {
        showAlt(title: "Date of Birth".localized, message: "Lorem ipsum dolor sit amet 18 years".localized, style: .alert)
    }
    
    // MARK: Outlet Action
    @IBAction func tapped(_ sender: Any) {
        navigates(to: .checkCredit(.location))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CheckCreditFormViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .allEvents)
    }
    
    // Get value from textfield
    @objc func valueChanged(_ textField: UITextField){
        switch textField.tag {
        case TextFieldData.nameTextField.rawValue:
            credit.name = textField.text ?? ""
            
        case TextFieldData.nidPassportTextField.rawValue:
            credit.nidpassport = textField.text ?? ""
            
        case TextFieldData.dobTextField.rawValue:
            credit.dob = textField.text ?? ""
            
        case TextFieldData.genderTextField.rawValue:
            credit.gender = textField.text ?? ""
            
        case TextFieldData.maritalStatusTextField.rawValue:
            credit.maritalStatus = textField.text ?? ""
            
        case TextFieldData.occupationTextField.rawValue:
            credit.occupation = textField.text ?? ""
            
        case TextFieldData.incomeTextField.rawValue:
            credit.income = textField.text ?? ""
            
        case TextFieldData.educationTextField.rawValue:
            credit.education = textField.text ?? ""
            
        case TextFieldData.workingPeriodTextField.rawValue:
            selectFirstRow(textField, workingPeriodPickerView) // picker
            credit.workingPeriod = textField.text ?? ""

        case TextFieldData.housingTypeTextField.rawValue:
            credit.housingType = textField.text ?? ""
            
        case TextFieldData.aeonLoanRepaymentTextField.rawValue:
            credit.aeonLoanRepayment = textField.text ?? ""
            
        case TextFieldData.otherLoanRepaymentTextField.rawValue:
            credit.otherLoanRepayment = textField.text ?? ""
        default:
            break
        }
    }
}
// MARK: - Date Picker
extension CheckCreditFormViewController {
    func setupDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() - 18.years
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized, style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        let cell = tableView.cellForRow(at: IndexPath(row: TextFieldData.dobTextField.rawValue, section: 0)) as! CheckCreditFormCell
        
        cell.textField.inputAccessoryView = toolbar
        cell.textField.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        let cell = tableView.cellForRow(at: IndexPath(row: TextFieldData.dobTextField.rawValue, section: 0)) as! CheckCreditFormCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell.textField.text = formatter.string(from: datePicker.date)
        credit.dob = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

// MARK: PickerView Delegate & DataSource
extension CheckCreditFormViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // select first row
    private func selectFirstRow(_ textField: UITextField,  _ picker: UIPickerView){
        guard textField.text!.isEmpty else {return}
        picker.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
    }
    
    // get tableview cell
    private func getCell(for field: TextFieldData) -> CheckCreditFormCell {
        
        return tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as! CheckCreditFormCell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return livings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCell(for: .workingPeriodTextField).textField.text = workings[row]
        credit.workingPeriod = workings[row]
    }
}




