//
//  CheckCreditFormViewModel.swift
//  AEON Loan
//
//  Created by aeon on 12/21/20.
//

import Foundation
import UIKit.UIImage

public class CheckCreditFormViewModel {
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<Response?> = Box(nil)
    var tableDatas: Box<[CheckCreditFieldData]?> = Box(nil)
    init() {
        generateData()
        //filter()
    }
    
    func generateData() {
        var datas = [CheckCreditFieldData]()
        let placeholders = ["1","2", "3", "4", "5", "6","7", "8", "9", "10", "11","12", "13", "14", "15", "16", "17", "18", "19", "20"]
        for (_,v) in placeholders.enumerated() {
            datas.append(CheckCreditFieldData(placeholder: v, icon: UIImage(systemName: "calendar") ?? UIImage()))
        }
        
        tableDatas.value = datas
    }
    
//    func filter() {
//        var data = [TextFieldData.provinceTextField, TextFieldData.districtTextField]
//
//        let filtered = TextFieldData.allCases.filter { $0 != .provinceTextField }
//
//        print("Data1", filtered)
//    }
    
}

enum TextFieldData: Int, CaseIterable {
    case nameTextField = 0
    case nidPassportTextField
    case dobTextField
    case genderTextField
    case maritalStatusTextField
    case occupationTextField
    case incomeTextField
    case educationTextField
    case workingPeriodTextField
    case housingTypeTextField
    case aeonLoanRepaymentTextField
    case otherLoanRepaymentTextField
    
    var placeholder: String {
        switch self {
        case .nameTextField: return "Username".localized
        case .nidPassportTextField: return "ID/Passport".localized
        case .dobTextField: return "Date of Birth".localized
        case .genderTextField: return "Gender".localized
        case .maritalStatusTextField: return "Marital Status".localized
        case .occupationTextField: return "Occupation".localized
        case .incomeTextField: return "Income".localized
        case .educationTextField: return "Education".localized
        case .workingPeriodTextField: return "Working Period".localized
        case .housingTypeTextField: return "Housing Type".localized
        case .aeonLoanRepaymentTextField: return "Aeon Repayment".localized
        case .otherLoanRepaymentTextField: return "Other Loan Repayment".localized
        }
    }
    
    private var iconName: String {
        switch self {
        case .nameTextField: return "person"
        case .nidPassportTextField: return "creditcard"
        case .dobTextField: return "calendar"
        case .genderTextField: return "gender"
        case .maritalStatusTextField: return "heart"
        case .occupationTextField: return "necktie"
        case .incomeTextField: return "dollarsign.circle"
        case .educationTextField: return "graduationcap"
        case .workingPeriodTextField: return"calendar"
        case .housingTypeTextField: return "house"
        case .aeonLoanRepaymentTextField: return "dollarsign.circle"
        case .otherLoanRepaymentTextField: return "dollarsign.circle"
        default: return ""
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .genderTextField, .occupationTextField:
            return UIImage(named: iconName)
        default:
            return UIImage(systemName: iconName)
        }
    }
}

struct CheckCredit {
    var name, nidpassport, dob, gender, maritalStatus,  occupation, income, education, livingPeriod, workingPeriod, housingType, aeonLoanRepayment, otherLoanRepayment, province, district, commune, village: String
    
    init(name: String = "", nidpassport: String = "", dob: String = "", gender: String = "", maritalStatus: String = "",  occupation: String = "" , income: String = "",education: String = "", livingPeriod: String = "", workingPeriod: String = "", housingType: String = "", aeonLoanRepayment: String = "", otherLoanRepayment: String = "", province:String = "", commune: String = "", district: String = "", village: String = "") {
        self.name = name
        self.nidpassport = nidpassport
        self.dob = dob
        self.gender = gender
        self.maritalStatus = maritalStatus
        self.occupation = occupation
        self.income = income
        self.education = education
        self.livingPeriod = livingPeriod
        self.workingPeriod = workingPeriod
        self.housingType = housingType
        self.aeonLoanRepayment = aeonLoanRepayment
        self.otherLoanRepayment = otherLoanRepayment
        self.province = province
        self.district = district
        self.commune = commune
        self.village = village
    }
}

struct CheckCreditFieldData{
    let placeholder: String
    let icon: UIImage
}


