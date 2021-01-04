//
//  Validator.swift
//  AEON Loan
//
//  Created by aeon on 10/1/20.
//

import Foundation
import UIKit.UITextField

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String
}

enum ValidatorType {
    case email
    case password
    case username
    case phone
    case other(message: String)
    case projectIdentifier
    case requiredField(field: String)
    case age
    case otp
    case uniqueUsername
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .username: return UserNameValidator()
        case .phone: return PhoneValidator()
        case .other(let msg): return OtherFieldValidator(msg)
        case .projectIdentifier: return ProjectIdentifierValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        case .otp: return OTPValidator()
        case .uniqueUsername: return UnigueUserNameValidator()
        }
    }
}

struct PhoneValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value != "" else {
            field.TextFieldBuzz()
            throw ValidationError("Phone Number is Required")
        }
        guard value.isPhone else {
            field.TextFieldBuzz()
            throw ValidationError("Invalid phone number")
        }
        return value
    }
}

struct OTPValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value != "" else {
            field.TextFieldBuzz()
            throw ValidationError("OTP Verification is Required".localized)
        }
        guard value.count == 6 && value.isDigit else {
            field.TextFieldBuzz()
            throw ValidationError("Invalid OTP Code")
        }
        return value
    }
}

// validate empty
struct OtherFieldValidator: ValidatorConvertible {
    private let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard !value.isEmpty else {
            field.TextFieldBuzz()
            throw ValidationError(message)
        }
        return value
    }
    
}

//"J3-123A" i.e
struct ProjectIdentifierValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z]{1}[0-9]{1}[-]{1}[0-9]{3}[A-Z]$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid Project Identifier Format")
            }
        } catch {
            throw ValidationError("Invalid Project Identifier Format")
        }
        return value
    }
}


class AgeValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value.count > 0 else {throw ValidationError("Age is required")}
        guard let age = Int(value) else {throw ValidationError("Age must be a number!")}
        guard value.count < 3 else {throw ValidationError("Invalid age number!")}
        guard age >= 18 else {throw ValidationError("You have to be over 18 years old to user our app :)")}
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard !value.isEmpty else {
            field.buzz()
            let kmMsg = "សូមបំពេញ " + fieldName
            let enMsg = fieldName + " is required"
            let message = Preference.language == .km ? kmMsg:enMsg
            throw ValidationError(message)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-z  ]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces,  or special characters")
        }
        return value
    }
}

struct UnigueUserNameValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value.count >= 1 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "^[0-9A-Za-z  ]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces,  or special characters")
        }
        return value
    }
}

struct PasswordValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        guard value != "" else {
            field.TextFieldBuzz()
            throw ValidationError("Password is Required")
        }
        guard value.count >= 6 else {
            field.TextFieldBuzz()
            throw ValidationError("Password must have at least 6 characters")
        }
        
        do {
            let pwdRegex = "^(.*){6,18}$"
//            let pwdRegex = "!\"#$%&'()*+,-/:;<=>?[\\]^_`{|}~"
//            let pweRegex2 = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
            if try NSRegularExpression(pattern: pwdRegex,  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                field.TextFieldBuzz()
                throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
            }
        } catch {
            field.TextFieldBuzz()
            throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
        }
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String, _ field: UITextField) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid e-mail Address")
            }
        } catch {
            throw ValidationError("Invalid e-mail Address")
        }
        return value
    }
}


extension UITextField {
    func TextFieldBuzz(){
        self.becomeFirstResponder()
        self.buzz()
    }
}
