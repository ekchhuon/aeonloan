//
//  CheckCreditFormViewController.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import UIKit

extension CheckCreditFormViewController {
    static func instantiate(item: String, loan: ApplyLoan?) -> CheckCreditFormViewController {
        let controller = CheckCreditFormViewController()
        controller.item = item
        controller.loan = loan
        return controller
    }
}

class CheckCreditFormViewController: BaseViewController, UITextFieldDelegate, WriteValueBackDelegate {
    private let viewModel = CheckCreditFormViewModel()
    private let pickerViewModel = CheckCreditPickerViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deneButton: UIButton!
    private let datePicker = UIDatePicker()
    private let workingPeriodPickerView = UIPickerView()
    var workings: [Variable.Data]?
    
    var item = ""
    var applicant = Applicant()
    var loan: ApplyLoan?
    let calculator = Calculator()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Check Credit")
        self.tableView.register(UINib(nibName: "CheckCreditFormCell", bundle: nil), forCellReuseIdentifier: "CheckCreditFormCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorInset = .zero
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.workingPeriodPickerView.delegate = self

        setupKeyboard(.numberPad, for: .incomeTextField)
        setupKeyboard(.numberPad, for: .otherLoanRepaymentTextField)
        deneButton.rounds(radius: 10)
        deneButton.backgroundColor = .brandPurple
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        let workingPeriodCell = getCell(for: .workingPeriodTextField)
        let usernameCell = getCell(for: .nameTextField)
        let nidPassportCell = getCell(for: .nidPassportTextField)
        workingPeriodCell.textField.inputView = workingPeriodPickerView
        usernameCell.textField.text = Preference.user.fullName
        nidPassportCell.textField.text = Preference.user.nidPassport

        setupDatePicker()
        bind()
        pickerViewModel.fetchVariable(with: .workingPeriod)
    }
    
    private func bind() {
        pickerViewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        pickerViewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "".localized ,message: msg)
        }
        pickerViewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "".localized, message: err.localized)
        }
        
        pickerViewModel.response.bind { [weak self] data in
            
            print("Data....", data)
            
            guard let self = self else { return }
            self.workings = data
            self.workingPeriodPickerView.reloadAllComponents()
        }
        
    }
    
    func writeBack(value: Any?) {
        if let (value, variable) = value as? (Variable.Data, VariableType) {
            switch variable {
            case .occupation:
                let row = TextFieldData.occupationTextField.rawValue
                updateTextFieldForRow(at: row , with: value)
                applicant.occupation = value.titleEn ?? value.titleKh ?? ""
                applicant.occupationId = value.id
            case .maritalStatus:
                let row = TextFieldData.maritalStatusTextField.rawValue
                updateTextFieldForRow(at: row , with: value)
                applicant.maritalStatus = value.titleEn ?? value.titleKh ?? ""
                applicant.maritalStatusId = value.id
            case .gender:
                let row = TextFieldData.genderTextField.rawValue
                updateTextFieldForRow(at: row , with: value)
                applicant.gender = value.titleEn ?? value.titleKh ?? ""
                applicant.genderId = value.id
            case .education:
                let row = TextFieldData.educationTextField.rawValue
                updateTextFieldForRow(at: row , with: value)
                applicant.education = value.titleEn ?? value.titleKh ?? ""
                applicant.educationId = value.id
            case .houseType:
                let row = TextFieldData.housingTypeTextField.rawValue
                updateTextFieldForRow(at: row , with: value)
                applicant.housingType = value.titleEn ?? value.titleKh ?? ""
                applicant.housingTypeId = value.id
            default: break
            }
        }
    }
    
    // assign writeback value to textfield
    private func updateTextFieldForRow(at row: Int, with value: Variable.Data) {
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! CheckCreditFormCell
        cell.textField.text = value.titleEn // Preference.language == .en ? value.titleEn : value.titleKh
    }
    
    private func setupKeyboard(_ keyboard: UIKeyboardType, for textfield: TextFieldData ) {
        getCell(for: textfield).textField.keyboardType = keyboard
    }
}

// MARK: - Table Delegate & Datasource
extension CheckCreditFormViewController: UITableViewDataSource, UITableViewDelegate {
    // get tableview cell
    private func getCell(for field: TextFieldData) -> CheckCreditFormCell {
        
        return tableView.cellForRow(at: IndexPath(row: field.rawValue, section: 0)) as! CheckCreditFormCell
    }
    
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
            let controller = PickerViewController.instantiate(.occupation, applicant.occupation)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .educationTextField:
            let controller = PickerViewController.instantiate(.education, applicant.education)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .maritalStatusTextField:
            let controller = PickerViewController.instantiate(.maritalStatus, applicant.maritalStatus)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .genderTextField:
            let controller = PickerViewController.instantiate(.gender, applicant.gender)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        case .housingTypeTextField:
            let controller = PickerViewController.instantiate(.houseType, applicant.housingType)
            navigationController?.pushViewController(controller, animated: true)
            controller.writeBackDelegate = self
        default:
            break
        }
        
    }
    
    @objc func otherLoanQuestionMarkTapped() {
        showAlt(title: "Other Loan Repayment".localized, message: "Lorem ipsum dolor sit amet".localized, style: .alert)
    }
    
    @objc func dobQuestionMarkTapped() {
        showAlt(title: "Date of Birth".localized, message: "Applicant age must be at least \(Date() - 21.years) years old".localized, style: .alert)
    }
    
    // MARK: Outlet Action
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        
        
        
        
        //navigates(to: .checkCredit(.location))
        applicant.age = "\(applicant.dob.asAge)"
        calculator.income = applicant.income.asDouble
        calculator.otherLoan = applicant.loanRepayment.asDouble
        applicant.repaymentRadio = "\(calculator.calculate(.ratio))"
        print("dsafafas===>", applicant)
        validate {
            self.navigates(to: .checkCredit(.location(self.applicant, self.loan)))
        }
    }
    
    // convenience
    private func getFieldName(for field: TextFieldData) -> String {
        return field.placeholder
    }
    
    
    private func validate(completion: @escaping () -> Void) {
        do {
            _ = try getCell(for: .nameTextField).textField.validatedText(type: .requiredField(field: TextFieldData.nameTextField.placeholder))
            _ = try getCell(for: .nidPassportTextField).textField.validatedText(type: .requiredField(field: TextFieldData.nidPassportTextField.placeholder))
            _ = try getCell(for: .dobTextField).textField.validatedText(type: .requiredField(field: TextFieldData.dobTextField.placeholder))
            _ = try getCell(for: .genderTextField).textField.validatedText(type: .requiredField(field: TextFieldData.genderTextField.placeholder))
            _ = try getCell(for: .maritalStatusTextField).textField.validatedText(type: .requiredField(field: TextFieldData.maritalStatusTextField.placeholder))
            _ = try getCell(for: .occupationTextField).textField.validatedText(type: .requiredField(field: TextFieldData.occupationTextField.placeholder))
            _ = try getCell(for: .incomeTextField).textField.validatedText(type: .requiredField(field: TextFieldData.incomeTextField.placeholder))
            _ = try getCell(for: .educationTextField).textField.validatedText(type: .requiredField(field: TextFieldData.educationTextField.placeholder))
            _ = try getCell(for: .workingPeriodTextField).textField.validatedText(type: .requiredField(field: TextFieldData.workingPeriodTextField.placeholder))
            _ = try getCell(for: .housingTypeTextField).textField.validatedText(type: .requiredField(field: TextFieldData.housingTypeTextField.placeholder))

            completion()
        } catch (let error) {
            showAlt(title: (error as! ValidationError).message, message: "", style: .alert)
        }
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
            applicant.name = textField.text ?? ""
            
        case TextFieldData.nidPassportTextField.rawValue:
            applicant.id = textField.text ?? ""
            
        case TextFieldData.dobTextField.rawValue:
            applicant.dob = textField.text ?? ""
            
        //        case TextFieldData.genderTextField.rawValue:
        //            credit.gender = textField.text ?? ""
        
        //        case TextFieldData.maritalStatusTextField.rawValue:
        //            credit.maritalStatus = textField.text ?? ""
        
        //        case TextFieldData.occupationTextField.rawValue:
        //            credit.occupation = textField.text ?? ""
        
        case TextFieldData.incomeTextField.rawValue:
            applicant.income = textField.text ?? ""
            
        //        case TextFieldData.educationTextField.rawValue:
        //            credit.education = textField.text ?? ""
        
        case TextFieldData.workingPeriodTextField.rawValue:
            selectFirstRow(textField, workingPeriodPickerView) // picker
            applicant.workingPeriod = textField.text ?? ""
            
        //        case TextFieldData.housingTypeTextField.rawValue:
        //            credit.housingType = textField.text ?? ""
        
        case TextFieldData.otherLoanRepaymentTextField.rawValue:
            applicant.loanRepayment = textField.text ?? ""
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
        datePicker.maximumDate = Date() - 21.years
        
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
        formatter.dateFormat = "yyyy/MM/dd"
        cell.textField.text = formatter.string(from: datePicker.date)
        applicant.dob = formatter.string(from: datePicker.date)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workings?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = Preference.language == .km ? workings?[row].titleKh : workings?[row].titleEn
        return workings?[row].titleEn
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCell(for: .workingPeriodTextField).textField.text = workings?[row].titleEn
        applicant.workingPeriod = workings?[row].titleEn ?? "Null"  // workings?[row].titleEn ?? workings?[row].titleKh ?? ""
        applicant.workingPeriodId = workings?[row].id ?? ""
    }
}


