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
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brandPurple
        containerView.setBorder(15)
        select(segment: .first)
    }
    
    fileprivate func select(segment: Segment) {
        buttons.forEach {
            $0.backgroundColor = .brandPurple
            $0.setTitleColor(.white, for: .normal)
            $0.dropShadow()
            $0.setBorder()
        }
        buttons[segment.index].setTitleColor(.brandPurple, for: .normal)
        buttons[segment.index].backgroundColor = .white
//        createChild(for: segment)
    }
    
    fileprivate func createChild(for segment: Segment) {
        let firstController = FirstSegmentViewController.instantiate()
        let secondController = SecondSegmentViewController.instantiate()
        let controllers = [firstController, secondController]
        let childView = controllers[segment.index].view
        childView?.translatesAutoresizingMaskIntoConstraints = false
        self.add(child: controllers[segment.index])
        childView?.setLeft(equalTo: containerView.leftAnchor, constant: 20)
        childView?.setTop(equalTo: containerView.topAnchor, constant: 20)
        childView?.setRight(equalTo: containerView.rightAnchor, constant: -20)
        childView?.setBottom(qualTo: containerView.bottomAnchor, constant: -20)
    }
    
    

    @IBAction func firstSegmentButtonTapped(_ sender: Any) {
        select(segment: .first)
    }
    @IBAction func secondSegmentButtonTapped(_ sender: Any) {
        select(segment: .second)
    }
    
}




