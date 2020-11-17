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
        if texts.has("idkhm") && texts.hasId(.nId(.khmer)) {
            return .nId(.khmer)
        } else if texts.has("passport") && texts.has("KINGDOM OF CAMBODIA") && texts.has("KHM") {
            return .passport(.khmer)
        } else if texts.has("passport") && texts.has("jpn") && texts.has("Japan") {
            return .passport(.japanese)
        } else {
            return .unknown
        }
    }
}
