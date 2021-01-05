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
//    var tableDatas: Box<[CheckCreditFieldData]?> = Box(nil)
    init() {
//        generateData()
        //filter()
    }
    
//    func generateData() {
//        var datas = [CheckCreditFieldData]()
//        let placeholders = ["1","2", "3", "4", "5", "6","7", "8", "9", "10", "11","12", "13", "14", "15", "16", "17", "18", "19", "20"]
//        for (_,v) in placeholders.enumerated() {
//            datas.append(CheckCreditFieldData(placeholder: v, icon: UIImage(systemName: "calendar") ?? UIImage()))
//        }
        
//        tableDatas.value = datas
//    }
    
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
        case .otherLoanRepaymentTextField: return "dollarsign.circle"
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
/*
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
 */
/*
 {
 "name": "", // Username
 "id": "", // Nid or Passport
 "dob": "2020/1/12", // Date of birth
 "age": "46", // Age
 "genderId": "58",
 "gender": "MALE",
 "maritalStatusId": "56",
 "maritalStatus": "Married",
 "provinceCode": "",
 "districtCode": "",
 "communeCode": "",
 "villageCode": "",
 "livingPeriod": "62",
 "occupationId": "41",
 "occupation": "PC > 50 STAFF",
 "income": "350",
 "educationId": "28",
 "education": "PRIMARY SCHOOL",
 "workingPeriod": "32",
 "repaymentRadio": "31",
 "housingTypeId": "24",
 "housingType": "OWNER",
 "loanRepaymentOther": "0"
 }
 */


struct Applicant: Codable {
    var name, id, dob, age, genderId, gender, maritalStatusId, maritalStatus,
        provinceCode, districtCode, communeCode, villageCode, livingPeriod, livingPeriodId, occupationId, occupation, income, educationId, education, workingPeriod, workingPeriodId, repaymentRadio, housingTypeId, housingType, loanRepayment: String
    
    init(name: String = "", id: String = "", dob: String = "", age: String = "" , genderId: String = "", gender: String = "", maritalStatusId: String = "", maritalStatus: String = "", provinceCode: String = "", districtCode: String = "", communeCode: String = "", villageCode: String = "", livingPeriod: String = "", livingPeriodId: String = "",occupationId: String = "", occupation: String = "", income: String = "", educationId: String = "", education: String = "", workingPeriod: String = "", workingPeriodId: String = "", repaymentRadio: String = "", housingTypeId: String = "", housingType: String = "", loanRepayment: String = "0") {
        self.name = name
        self.id = id
        self.dob = dob
        self.age = age
        self.genderId = genderId
        self.gender = gender
        self.maritalStatusId = maritalStatusId
        self.maritalStatus = maritalStatus
        self.occupationId = occupationId
        self.occupation = occupation
        self.income = income
        self.educationId = educationId
        self.education = education
        self.workingPeriod = workingPeriod
        self.workingPeriodId = workingPeriodId
        self.repaymentRadio = repaymentRadio
        self.housingTypeId = housingTypeId
        self.housingType = housingType
        self.loanRepayment = loanRepayment
        self.provinceCode = provinceCode
        self.districtCode = districtCode
        self.communeCode = communeCode
        self.villageCode = villageCode
        self.livingPeriod = livingPeriod
        self.livingPeriodId = livingPeriodId
    }
}

struct CheckCreditFieldData{
    let placeholder: String
    let icon: UIImage
}


