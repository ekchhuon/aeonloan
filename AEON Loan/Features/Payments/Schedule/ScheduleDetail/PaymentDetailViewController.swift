//
//  PaymentDetailViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/15/20.
//

import UIKit
import PDFKit

extension PaymentDetailViewController {
    static func instantiate(item: String) -> PaymentDetailViewController {
        let controller = PaymentDetailViewController()
        controller.agreement = item
        return controller
    }
}

class PaymentDetailViewController: BaseViewController {
    private let viewModel = PaymentDetailViewModel()
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var agreementNumber: UILabel!
    var agreement = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("Payment Details".localized)
//        self.agreementNumber.text = agreement
        
        if let path = Bundle.main.path(forResource: "sample", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
    }
    
}
