//
//  ApplicantInfoViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import UIKit

extension ApplicantInfoViewController {
    static func instantiate() -> ApplicantInfoViewController {
        return ApplicantInfoViewController()
    }
}

class ApplicantInfoViewController: BaseViewController {
    private let viewModel = ApplicantInfoViewModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var NIDTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var maritalStatusTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var livingPeriodTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var eduTextField: UITextField!
    @IBOutlet weak var workingPeroidTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var textFields: [UITextField]!
    
    let maritalPickerView = UIPickerView()
    let occupationPickerView = UIPickerView()
    let eduPickerView = UIPickerView()
    let workingPeriodPickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    var pickerFields = [UITextField]()
    var pickerViews = [UIPickerView]()
    
    // dummy
    var maritals = [String]()
    var occupations = [String]()
    var educations = [String]()
    var periods = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        setupDatePicker()
    }
    
    private func bind(){
        viewModel.loading.bind { [weak self] (loading) in
            guard let self = self else { return }
            self.show(indicator: loading)
        }
        viewModel.maritals.bind { [weak self] (maritals) in
            guard let self = self else { return }
            self.maritals = maritals
        }
        
        viewModel.occupations.bind { [weak self] (occs) in
            guard let self = self else { return }
            self.occupations = occs
        }
        
        viewModel.educations.bind { [weak self] (edus) in
            guard let self = self else { return }
            self.educations = edus
        }
        
        viewModel.periods.bind { [weak self] (prds) in
            guard let self = self else { return }
            self.periods = prds
        }
    }
    
    func setupView() {
        submitButton.rounds(radius: 10, background: .brandPurple)
        pickerFields = [maritalStatusTextField, occupationTextField, eduTextField, workingPeroidTextField]
        pickerViews = [maritalPickerView, occupationPickerView, eduPickerView, workingPeriodPickerView]
        setupTextFields()
        setupPickerView()
    }
    
    func setupTextFields(){
        let placeholders = ["Name", "ID/Passport", "Date of Birth", "Marital Status", "Current Address", "Living Period", "Occupation", "Income", "Education", "Working Peroid"]
        
        for (index, field) in textFields.enumerated() {
            field.placeholder = NSLocalizedString(placeholders[index], comment: "")
            field.delegate = self
        }
    }
    
    func setupPickerView() {
        for (index, field) in pickerFields.enumerated() {
            field.inputView = pickerViews[index]
        }
        
        pickerViews.forEach {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func setupDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
    }
    
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // MARK: Outlet Action
    @IBAction func submitButtonTapped(_ sender: Any) {
        navigates(to: .checkCredit(.result(.accepted)))
        // navigates(to: .checkCredit(.result(.rejected)))
    }
}

// MARK: PickerView Delegate & DataSource
extension ApplicantInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerViews[0]:
            return maritals.count
        case pickerViews[1]:
            return occupations.count
        case pickerViews[2]:
            return educations.count
        case pickerViews[3]:
            return periods.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerViews[0]:
            return maritals[row]
        case pickerViews[1]:
            return occupations[row]
        case pickerViews[2]:
            return educations[row]
        case pickerViews[3]:
            return periods[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerViews[0]:
            maritalStatusTextField.text = maritals[row]
        case pickerViews[1]:
            occupationTextField.text = occupations[row]
        case pickerViews[2]:
            eduTextField.text = educations[row]
        case pickerViews[3]:
            workingPeroidTextField.text = periods[row]
        default: break
        }
    }
    
}

// MARK: TextField Delegate
extension ApplicantInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case pickerFields[0]:
            preSelect(textField, pickerViews[0])
        case pickerFields[1]:
            preSelect(textField, pickerViews[1])
        case pickerFields[2]:
            preSelect(textField, pickerViews[2])
        case pickerFields[3]:
            preSelect(textField, pickerViews[3])
        default: break
        }
    }
    // select first row
    func preSelect(_ textField: UITextField,  _ picker: UIPickerView){
        guard textField.text!.isEmpty else {return}
        picker.selectRow(0, inComponent: 0, animated: true)
        self.pickerView(picker, didSelectRow: 0, inComponent: 0)
    }
    
}
