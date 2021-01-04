//
//  LocationListViewModel.swift
//  AEON Loan
//
//  Created by aeon on 12/16/20.
//

import Foundation
public class LocationListViewModel {
    
    let status: Box<RequestStatus?> = Box(nil)
    let message: Box<String?> = Box(nil)
    let error: Box<APIError?> = Box(nil)
    let response: Box<[Location.Data]?> = Box(nil)
    
    init() {
        //getProvince()
    }
    
    func fetchLocaiton(for type: LocationType, with code: String) {
        let header = Header()
        let pro = Param.Province(header: header, body: code)
        let dist = Param.District(header: header, body: Param.District.Body(provinceCode: code))
        let com = Param.Commune(header: header, body: Param.Commune.Body(districtCode: code))
        let vil = Param.Village(header: header, body: Param.Village.Body(communeCode: code))
        status.value = .started
        
        let param: ParamLocation
        
        switch type {
        case .province: param = .province(pro.toJSON())
        case .district: param = .district(dist.toJSON())
        case .commune: param = .commune(com.toJSON())
        case .village: param = .village(vil.toJSON())
        }
        
        APIClient.getLocation(for: param) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                self.response.value = data.body.data
            case let .failure(err):
            self.error.value = err.evaluate
            }
        }
    }
    
    func getProvince() {
        let header = Header()
        let pro = Param.Province(header: header, body: "")
//        let dist = Param.District(header: header, body: Param.District.Body(provinceCode: "24"))
//        let com = Param.Commune(header: header, body: Param.Commune.Body(districtCode: "0104"))
//        let vil = Param.Village(header: header, body: Param.Village.Body(communeCode: "010402"))
        status.value = .started
        APIClient.getLocation(for: .province(pro.toJSON())) { [weak self] (result) in
            guard let self = self else {return}
            self.status.value = .stopped
            switch result {
            case let .success(data):
                guard data.body.success else {
                    self.message.value = data.body.message; return
                }
                self.response.value = data.body.data
            case let .failure(err):
            self.error.value = err.evaluate
            }
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
    
}
