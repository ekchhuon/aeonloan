//
//  Upload.swift
//  AEON Loan
//
//  Created by aeon on 12/7/20.
//

import Foundation
import Alamofire


enum Router: URLConvertible {
    
//    func asURL() throws -> URL {
//        <#code#>
//    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constantss.server.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
    }
    
    case CreateUser([String: AnyObject])
    case ReadUser(String)
    case UpdateUser(String, [String: AnyObject])
    case DestroyUser(String)

    var method: Alamofire.HTTPMethod {
        switch self {
        case .CreateUser:
            return .post
        case .ReadUser:
            return .get
        case .UpdateUser:
            return .put
        case .DestroyUser:
            return .delete
        }
    }

    var path: String {
        switch self {
        case .CreateUser:
            return "/users"
        case .ReadUser(let username):
            return "/users/\(username)"
        case .UpdateUser(let username, _):
            return "/users/\(username)"
        case .DestroyUser(let username):
            return "/users/\(username)"
        }
    }
}

class Upload {
    
    enum Uploadsss {
        case profile, document
        private var path: String {
            switch self {
            case .profile: return "profile"
            case .document: return "nid_passport"
            }
        }
        var url: URL? {
            let url = try? Constantss.server + path
            return url as URLConvertible
        }
    }
    
    func upload(route:Router, image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ result: Bool) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        let parameters = ["encode": String.random(length: 32).encrypt()]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: "file",
                                         fileName: "\(Date().currentTimeMillis())",
                                         mimeType: "image/jpeg")
                
                for (key, value) in parameters {
                    multipartFormData.append(value.asData, withName: key)
                }
            },
            to: Constantss.server , usingThreshold: UInt64.init(), method: .post)
            
            .uploadProgress { progress in
                progressCompletion(Float(progress.fractionCompleted))
            }
            .response { response in
                debugPrint(response)
            }
            
    }
    
    /*
     
     //MARK: - Upload image using alamofire with multiparts
     func uploadImageAPIResponse(postPath:String,img: UIImage, parameters:NSDictionary, requestType: RequestType){
     let imgData = img.jpegData(compressionQuality: 0.5)!
     let headers: HTTPHeaders = ["Authorization": "Your_Auth if any otherwise remove Header from request"]
     print("postPath:\(postPath)\nheaders:\(headers)\nparameters: \(parameters)")
     
     AF.upload(multipartFormData: { multipartFormData in
     multipartFormData.append(imgData, withName: "file",fileName: "profile.jpg", mimeType: "image/jpg")
     for (key, value) in parameters {
     multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
     } //Optional for extra parameters
     },
     to:postPath)
     { (result) in
     switch result {
     case .success(let upload, _, _):
     
     upload.uploadProgress(closure: { (progress) in
     print("Upload Progress: \(progress.fractionCompleted)")
     })
     
     upload.responseJSON { response in
     print(response.result.value as Any)
     
     if  response.result.isSuccess
     {   let httpStatusCode: Int = (response.response?.statusCode)!
     let data = (response.result.value as? NSDictionary)!
     let meta = (data["meta"] as? NSDictionary)!
     let code = meta["code"] as? Int ?? 0
     print(data)
     //if (data["success"] as? Bool)! {
     print("httpCode" + String(httpStatusCode))
     print("code" + String(code))
     switch(httpStatusCode) {
     case 200://operation successfull
     if code == 401 {
     let deleg = UIApplication.shared.delegate as! AppDelegate
     User.defaultUser.logoutUser()
     deleg.showLoginScreen()
     }
     self.delegate?.requestFinished(responseData: data, requestType: requestType)
     break
     case 204://no data/content found
     self.delegate?.requestFinished(responseData: data, requestType: requestType)
     break
     case 401://Request from unauthorized resource
     
     self.delegate?.requestFailed(error: "Request from unauthorized resource", requestType: requestType)
     break
     case 500://Internal server error like query execution failed or server script crashed due to some reason.
     self.delegate?.requestFailed(error: "Internal server error like query execution failed or server script crashed due to some reason.", requestType: requestType)
     break
     default:
     self.delegate?.requestFinished(responseData: data, requestType: requestType)
     break
     }
     }
     else
     {
     self.delegate?.requestFailed(error: (response.result.error?.localizedDescription)!, requestType: requestType)
     }
     
     }
     
     case .failure(let encodingError):
     print(encodingError)
     self.delegate?.requestFailed(error: encodingError.localizedDescription, requestType: requestType)
     }
     }
     
     }
     
     */
}
