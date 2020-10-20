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
  
}
