//
//  CalculatorViewController.swift
//  AEON Loan
//
//  Created by aeon on 10/20/20.
//

import UIKit

extension CalculatorViewController {
    static func instantiate() -> CalculatorViewController {
        return CalculatorViewController()
    }
}

class CalculatorViewController: BaseViewController, UITextFieldDelegate {
    private let viewModel = CalculatorViewModel()
    private let calculator = Calculator()
    enum Segment: Int {
        case first = 0
        case second = 1
        var index: Int {
            return self.rawValue
        }
    }
    @IBOutlet var segmentButtons: [UIButton]!
    @IBOutlet var calculateButtons: [UIButton]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var fieldTitleLabels: [UILabel]!
    @IBOutlet var currencyButtons: [UIButton]!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var calculationResultLabel: UILabel!
    
    var currency: Currency = .usd
    var segment: Segment = .first
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        select(segment: segment)
        select(currency: currency)
        setup(title: "Loan Calculation".localized)
        
        textFields.forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            disableCalculateButtons(disabled: $0.text!.isEmpty)
        }
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = .brandPurple
        containerView.setBorder(15)
        calculateButtons.forEach {
            $0.setBorder()
            $0.backgroundColor = .brandPurple
        }
        textFields.forEach { $0.setBorder(border: .brandPurple, width: 1) }
        [inputLabel, resultLabel].forEach { $0.textColor = .brandYellow }
    }
    
    // switch segment
    fileprivate func select(segment: Segment) {
        self.segment = segment
        segmentButtons.forEach {
            $0.backgroundColor = .brandPurple
            $0.setTitleColor(.white, for: .normal)
            $0.dropShadow()
            $0.setBorder()
        }
        segmentButtons[segment.index].setTitleColor(.brandPurple, for: .normal)
        segmentButtons[segment.index].backgroundColor = .white
        changeView(for: segment)
    }
    
    // switch currency
    fileprivate func select(currency: Currency) {
        self.currency = currency
        currencyButtons.forEach {
            $0.backgroundColor = .white
            $0.setTitleColor(.brandPurple, for: .normal)
            $0.setBorder()
        }
        currencyButtons[currency.index].setTitleColor(.white, for: .normal)
        currencyButtons[currency.index].backgroundColor = .brandPurple
    }
    
    fileprivate func changeView(for segment: Segment) {
        let flexibleTitles = ["Finance Amount", "Re-Payment"]
        fieldTitleLabels[0].text = flexibleTitles[segment.index].localized
        fieldTitleLabels[3].text = flexibleTitles.reversed()[segment.index].localized
    }
    
    fileprivate func disableCalculateButtons(disabled: Bool) {
        calculateButtons.forEach {
            $0.isUserInteractionEnabled = !disabled
            $0.alpha = disabled ? 0.5 : 1
        }
    }
    
    fileprivate func updateFieldValue() {
        calculator.amount = Double(textFields[0].text!)!
        calculator.rate = Double(textFields[1].text!)!
        calculator.term = Double(textFields[2].text!)!
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let containEmpty = textFields.contains { $0.text!.isEmpty } // true if every field has value
        disableCalculateButtons(disabled: containEmpty)
        containEmpty ? nil : updateFieldValue()
    }
}

// MARK: - Outlet action
extension CalculatorViewController {
    @IBAction func firstSegmentButtonTapped(_ sender: Any) {
        select(segment: .first)
    }
    @IBAction func secondSegmentButtonTapped(_ sender: Any) {
        select(segment: .second)
    }
    
    @IBAction func flateRateButtonTapped(_ sender: Any) {
        let result = calculator.calculate(.repayment(.flatRate))
        calculationResultLabel.text = "\(currency.symbol) " + result.format(for: currency)
    }
    
    @IBAction func effectiveRateButtonTapped(_ sender: Any) {
        let result = calculator.calculate(.repayment(.effectiveRate))
        calculationResultLabel.text = "\(currency.symbol) " + result.format(for: currency)
    }
    
    @IBAction func USDButtonTapped(_ sender: Any) {
        select(currency: .usd)
    }
    
    @IBAction func KHRButtonTapped(_ sender: Any) {
        select(currency: .khr)
    }
}


