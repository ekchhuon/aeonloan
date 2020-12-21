//
//  TouchIDAuth.swift
//  AEON Loan
//
//  Created by aeon on 10/20/20.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class BiometricIDAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    //  check whether the device can implement biometric authentication.
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }
    
    func authenticateUser(completion: @escaping (_ status: Bool , _ message: String?) -> Void) { // 1
        // 2
        guard canEvaluatePolicy() else {
            completion(false, "Touch ID not available")
            return
        }
        
        // 3
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in
            // 4
            if success {
                DispatchQueue.main.async { [unowned self] in
                    // User authenticated successfully, take appropriate action
                    completion(true, nil)
                }
            } else {
                // TODO: deal with LAError cases
                // 1
                let message: String
                
                // 2
                switch evaluateError {
                // 3
                case LAError.authenticationFailed?:
                    message = "There was a problem verifying your identity."
                case LAError.userCancel?:
                    message = "You pressed cancel."
                case LAError.userFallback?:
                    message = "You pressed password."
                case LAError.biometryNotAvailable?:
                    message = "Face ID/Touch ID is not available."
                case LAError.biometryNotEnrolled?:
                    message = "Face ID/Touch ID is not set up."
                case LAError.biometryLockout?:
                    message = "Face ID/Touch ID is locked."
                default:
                    message = "Face ID/Touch ID may not be configured"
                }
                // 4
                completion(false, message)
            }
        }
    }
    
    func tryBiometricAuthentication(completion: @escaping (_ status: Bool , _ message: String?) -> Void) {
        // 1
        let context = LAContext()
        var error: NSError?
        
        // 2
        
        guard canEvaluatePolicy() else {
            guard let errorString = error?.localizedDescription else {return}
            print("Error in biometric policy evaluation: \(errorString)")
            completion(false, "Touch ID not available")
            return
        }
        
        // 3
        let reason = "Authenticate to unlock App."
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason) { authenticated, error in
            // 4
            DispatchQueue.main.async {
                if authenticated {
                    // 5
                    //self.noteLocked = false
                } else {
                    // 6
                    if let errorString = error?.localizedDescription {
                        print("Error in biometric policy evaluation: \(errorString)")
                    }
                    //self.showUnlockModal = true
                    guard let error = error else {
                        debugPrint("Biometric Fatal Error")
                        return
                    }
                    self.errorMessage(error: error)
                    
                }
            }
        }
    }
    
    
    func errorMessage(error: Error) -> (message:String, code:LAError.Code?){
        
        var message = ""
        var code:LAError.Code?
        switch error {
        
        case LAError.authenticationFailed:
            message = "Authentication Failed"
            code = .authenticationFailed
        case LAError.userCancel:
            message = "User Cancel"
            code = .userCancel
        case LAError.systemCancel:
            message = "System Cancel"
            code = .systemCancel
        case LAError.passcodeNotSet:
            message = "Please goto the Settings & Turn On Passcode"
            code = .passcodeNotSet
        case LAError.biometryNotAvailable:
            message = "Face ID/Touch ID is not available"
            code = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            message = "Face ID/Touch ID is not set up."
            code = .biometryNotEnrolled
        case LAError.biometryLockout:
            message = "Face ID/Touch ID is locked."
            code = .biometryLockout
        case LAError.appCancel:
            message = "App Cancel"
            code = .userCancel
        case LAError.invalidContext:
            message = "Invalid Context"
            code = .invalidContext
        default:
            message = error.localizedDescription
            code = nil
            debugPrint("Biometric Fatal Error", error.localizedDescription)
        }
        return (message, code)
    }
    
    func tryBiometricAuthentications(completion: @escaping (_ status: Bool , _ message: String?, _ code: LAError.Code?) -> Void) {
        // 1
        let context = LAContext()
        var error: NSError?
        
        // 2
        if context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            // 3
            let reason = "Authenticate to unlock your note."
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason) { authenticated, error in
                // 4
                DispatchQueue.main.async {
                    if authenticated {
                        // 5
                        //self.noteLocked = false
                        completion(true, nil, nil)
                    } else {
                        // 6
                        if let errorString = error?.localizedDescription {
                            print("Error in biometric policy evaluation: \(errorString)")
                        }
                        
                        guard let error = error else {
                            debugPrint("Biometric Fatal Error")
                            return
                        }
                        let (message, code) = self.errorMessage(error: error)
                        completion(false, message , code)
                    }
                }
            }
        } else {
            // 7
            if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
            }
            
            guard let error = error else {
                debugPrint("Biometric Fatal Error")
                return
            }
            
            let (message, code) = self.errorMessage(error: error)
            completion(false, message , code)
        }
    }
    
    
}
