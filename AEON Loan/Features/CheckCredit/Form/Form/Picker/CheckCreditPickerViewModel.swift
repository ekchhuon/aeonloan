//
//  CheckCreditPickerViewModel.swift
//  AEON Loan
//
//  Created by aeon on 12/17/20.
//

import Foundation

public class CheckCreditPickerViewModel {
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<[Variable.Data]?> = Box(nil)
    
    init() {
        
    }
    
    func fetchVariable(with variable: VariableType) {
        let langCode = Preference.language == .en ? "01":"02"
        let header = Header(lan: langCode)
        let param = Param.Variable(header: header, body: Param.Variable.Body(id: variable.code))
        status.value = .started
        APIClient.fetchVariable(variable, param: param.toJSON()) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message + " [\(data.body.code)]"
                    return
                }
                self.response.value = data.body.data
            case let .failure(err):
            self.error.value = err.evaluate
            }
        }
    }
}

enum VariableType {
    case workingPeriod, livingPeriod, occupation, houseType, education, maritalStatus, gender
    var code: String {
        switch self {
        case .workingPeriod: return "3"
        case .livingPeriod: return "4"
        case .occupation: return "5"
        case .houseType: return "6"
        case .education: return "7"
        case .maritalStatus: return "9"
        case .gender: return "10"
        }
    }
    
    var value: String {
        switch self {
        case .workingPeriod: return "Working Period".localized
        case .livingPeriod: return "Living Period".localized
        case .occupation: return "Occupation".localized
        case .houseType: return "Housing Type".localized
        case .education: return "Education".localized
        case .maritalStatus: return "Marital Status".localized
        case .gender: return "Gender".localized
        }
    }
}
