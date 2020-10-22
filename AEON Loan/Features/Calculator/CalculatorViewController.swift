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

class CalculatorViewController: BaseViewController {
    private let viewModel = CalculatorViewModel()
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
    @IBOutlet var resultLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        select(segment: .first)
        setup(title: "Loan Calculation".localized)
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = .brandPurple
        containerView.setBorder(15)
        calculateButtons.forEach {
            $0.setBorder()
            $0.backgroundColor = .brandPurple
        }
        textFields.forEach {
            $0.setBorder(border: .brandPurple, width: 1)
        }
        resultLabels.forEach {
            $0.text = "Result".localized
        }
    }
    
    fileprivate func select(segment: Segment) {
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
    
    fileprivate func changeView(for segment: Segment) {
        let flexibleTitles = ["Finance Amount", "Re-Payment"]
        fieldTitleLabels[0].text = flexibleTitles[segment.index].localized
        fieldTitleLabels[3].text = flexibleTitles.reversed()[segment.index].localized
    }
    
    @IBAction func firstSegmentButtonTapped(_ sender: Any) {
        select(segment: .first)
    }
    @IBAction func secondSegmentButtonTapped(_ sender: Any) {
        select(segment: .second)
    }
    
    @IBAction func flateRateButtonTapped(_ sender: Any) {
        let base = Int(textFields[0].text!)!
        let pow = Int(textFields[1].text!)!
        textFields[3].text = String(base.expo(pow))
    }
    
    @IBAction func effectiveRateButtonTapped(_ sender: Any) {
    }
    
    
}




extension Int {
    func repaymentFlat(amount: Int, rate: Int, term: Int) -> Int {
        return amount * ((rate * term)+1/term)
    }
    
    func repaymentEffective(amount: Int, rate: Int, term: Int) -> Int {
        return amount * ( rate / 1 - (1 + rate).expo(-term))
    }
}

extension Int{
    func expo(_ power: Int) -> Int {
        var result = 1
        var powerNum = power
        var tempExpo = self
        while (powerNum != 0){
        if (powerNum%2 == 1){
            result *= tempExpo
        }
        powerNum /= 2
        tempExpo *= tempExpo
        }
        return result
    }
}
