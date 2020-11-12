//
//  DocumentValidator.swift
//  AEON Loan
//
//  Created by aeon on 11/11/20.
//

import Foundation

class DocumentValidator {
    var recognizedTexts:[String] = []
    func validate() -> DocumentType {
        let texts = recognizedTexts
        if texts.has("idkhm") && texts.hasDigit(of: 9)  {
            return .nId(.khmer)
        } else if texts.has("passport") && texts.has("KINGDOM OF CAMBODIA") && texts.has("KHM") {
            return .passport(.khmer)
        } else {
            return .unknown
        }
    }
}
