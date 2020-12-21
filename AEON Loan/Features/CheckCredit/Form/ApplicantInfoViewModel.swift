//
//  ApplicantInfoViewModel.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import Foundation
public class ApplicantInfoViewModel {
    let defaults = "Loading..."
    let user: Box<User?> = Box(nil)
    let username = Box("")
    let password = Box("")
    let loading = Box(false)
    
    var maritals = Box([String]())
    var occupations = Box([String]())
    var educations = Box([String]())
    var periods = Box([String]())
    
    var locationCode = ""
    
    init() {
        setupDummy()
        getProvince()
    }
    
    func getProvince() {
//        let param = Param.Request(header: <#T##Header#>, body: <#T##Param.Body#>)
//        APIClient.getProvince(param: <#T##Parameters#>, completion: <#T##(Result<Response, AFError>) -> Void#>)
        let header = Header(lan: "01")
        let pro = Param.Province(header: header, body: "")
        let dist = Param.District(header: header, body: Param.District.Body(provinceCode: "24"))
        let com = Param.Commune(header: header, body: Param.Commune.Body(districtCode: "0104"))
        let vil = Param.Village(header: header, body: Param.Village.Body(communeCode: "010402"))
        
        APIClient.getLocation(for: .province(pro.toJSON())) { (result) in
    
        }
        
//        APIClient.getLocation(for: .district(dist.toJSON())) { (result) in
//            
//        }
//        
//        APIClient.getLocation(for: .commune(com.toJSON())) { (result) in
//            
//        }
//        
//        APIClient.getLocation(for: .village(vil.toJSON())) { (result) in
//            
//        }
        
//        APIClient.getLocation(for: .province(param.toJSON())) { (result) in
//
//            print(result)
//
//        }
        
//        APIClient.getL(param: param.toJSON()) { (result) in
//            //self.status.value = .stopped
//            switch result {
//            case let .success(data):
//                print("Datataaa", data)
//                guard data.body.success else {
//                    //self.message.value = data.body.message; return
//                    return
//                }
//                //completion(data.body.data!.publicKey)
//            case let .failure(err):
//                print("Error", err)
//                //self.error.value = err.evaluate
//            }
//        }
    }
    
    func setupDummy() {
        loading.value = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loading.value = false
            self.maritals.value = [ "Single", "Married", "Divoced"]
            self.occupations.value = ["Teacher", "Accountant", "Consultant", "Engineer", "Programmer"]
            self.educations.value = ["Primary School", "Middle School" ,"BacII", "Colledge"]
            self.periods.value = ["6M", "6-12M", "12-36M", "36-60M", "60M" ]
        }
    }
}


