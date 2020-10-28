//
//  CalculatorViewController.swift
//  AEON Loan
//
//  Created by aeon on 10/20/20.
//

import UIKit

enum Housing {
    case owned
    case rental
    var index: Int {
        switch self {
        case .owned: return 0
        case .rental:return 1
        }
    }
    
    var rate: Double {
        switch self {
        case .owned: return 50.0.percent // 50%
        case .rental:return 40.0.percent // 40%
        }
    }
}

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

    @IBOutlet weak var containerView: UIView!
    //Outlets: Label
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    //Outlets: TextField Outletes
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var otherLoanTextField: UITextField!
    @IBOutlet weak var financeAmountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var loanTermTextField: UITextField!
    //Outlets: Button & Button Group
    @IBOutlet var segmentButtons: [UIButton]!
    @IBOutlet var currencyButtons: [UIButton]!
    @IBOutlet var housingTypeButtons: [UIButton]!
    @IBOutlet var calculateButtons: [UIButton]!

    @IBOutlet var loanLimitAdditionalStackViews: [UIStackView]!
    
    @IBOutlet weak var financeAmountStackView: UIStackView!
    
    var loanLimitTextFields: [UITextField]!
    var repaymentTextFields: [UITextField]!
    var allTextFields: [UITextField]!
    
    
    var currency: Currency = .usd
    var segment: Segment = .first
    var housing: Housing = .owned
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        select(segment: segment)
        select(currency: currency)
        select(housing: housing)
        setup(title: "Loan Calculation".localized)
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = .brandPurple
        containerView.setBorder(15)
        calculateButtons.forEach {
            $0.setBorder()
            $0.backgroundColor = .brandPurple
        }

        loanLimitTextFields = [incomeTextField, otherLoanTextField, interestRateTextField, loanTermTextField]
        repaymentTextFields = [financeAmountTextField, interestRateTextField, loanTermTextField]
        allTextFields = loanLimitTextFields + repaymentTextFields
        
        allTextFields.forEach {
            $0.delegate = self
            $0.setBorder(border: .brandPurple, width: 1)
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            disableCalculateButtons(disabled: $0.text!.isEmpty)
        }
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
        updateView(for: segment)
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
    
    fileprivate func select(housing: Housing) {
        self.housing = housing
        housingTypeButtons.forEach {
            $0.backgroundColor = .white
            $0.setTitleColor(.brandPurple, for: .normal)
            $0.setBorder(border: .brandPurple, width: 1)
            $0.dropShadow()
        }
        housingTypeButtons[housing.index].setTitleColor(.white, for: .normal)
        housingTypeButtons[housing.index].backgroundColor = .brandPurple
        updateFieldValue()
    }
    
    fileprivate func updateView(for segment: Segment) {
        let resultTitles = ["Re-Payment", "Finance Amount"]
        resultLabel.reset()
        resultTitleLabel.text = resultTitles[segment.index].localized
        loanLimitAdditionalStackViews.forEach {
            $0.isHidden = segment == .first
        }
        financeAmountStackView.isHidden = segment == .second
        let fields = segment == .first ? repaymentTextFields : loanLimitTextFields
        disableCalculateButtons(disabled: !(fields?.hasValue ?? false))
        
    }
    
    fileprivate func disableCalculateButtons(disabled: Bool) {
        calculateButtons.forEach {
            $0.isUserInteractionEnabled = !disabled
            $0.alpha = disabled ? 0.5 : 1
        }
    }
    
    fileprivate func updateFieldValue() {
        calculator.income = incomeTextField.text?.asDouble ?? 0.0
        calculator.otherLoan = otherLoanTextField.text?.asDouble ?? 0.0
        calculator.amount = financeAmountTextField.text?.asDouble ?? 0.0
        calculator.rate = interestRateTextField.text?.asDouble ?? 0.0
        calculator.term = loanTermTextField.text?.asDouble ?? 0.0
        calculator.housing = housing
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let fields = segment == .first ? repaymentTextFields : loanLimitTextFields
        disableCalculateButtons(disabled: !(fields?.hasValue ?? false))
        
        textField.text?.prefix(4)
        
        updateFieldValue()
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
    @IBAction func USDButtonTapped(_ sender: Any) {
        select(currency: .usd)
    }
    @IBAction func KHRButtonTapped(_ sender: Any) {
        select(currency: .khr)
    }
    @IBAction func ownHouseButtonTapped(_ sender: Any) {
        select(housing: .owned)
    }
    @IBAction func rentalHouseButtonTapped(_ sender: Any) {
        select(housing: .rental)
    }
    @IBAction func flateRateButtonTapped(_ sender: Any) {
        let repayResult = calculator.calculate(.repayment(.flatRate))
        let loanResult = calculator.calculate(.loanLimit(.flatRate))
        let result = segment == .first ? repayResult : loanResult
        resultLabel.text = "\(currency.symbol) " + result.format(for: currency)
        calculator.value()
    }
    @IBAction func effectiveRateButtonTapped(_ sender: Any) {
        let repayResult = calculator.calculate(.repayment(.effectiveRate))
        let loanResult = calculator.calculate(.loanLimit(.effectiveRate))
        let result = segment == .first ? repayResult : loanResult
        resultLabel.text = "\(currency.symbol) " + result.format(for: currency)
        
        calculator.value()
    }
}


extension String {
    var asDouble: Double {
        return Double(self) ?? 0.0
    }
}

extension Array where Element == UITextField {
    /// ensure all fields have value
    var hasValue: Bool {
        return !(self.contains{ $0.text?.isEmpty ?? false })
    }
}

extension UILabel {
    func reset() {
        self.text = ""
    }
}
