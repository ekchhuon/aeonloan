//
//  RegisterViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit
import SwiftyRSA
import CryptoKit


extension RegisterViewController {
    static func instantiate() -> RegisterViewController {
        return RegisterViewController()
    }
}

class RegisterViewController: BaseViewController {
    private let viewModel = RegisterViewModel()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var eyeballButtons: [UIButton]!
    
    var secured: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func bind() {
        viewModel.loading.bind { (loading) in
            self.showIndicator(loading)
        }
        
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err  else { return }
            self.showAlert(title: "\(err.code) \(err.description) ", message: "\(err.localized)")
        }
        
        //        viewModel.success.bind { (success) in
        //
        //            self.showAlert(message: success)
        //        }
        
        viewModel.success.bind { [weak self] msg in
            guard let self = self, !msg.isEmpty else { return }
//            self.showAlert(message: msg)
        }
        
        viewModel.isRegisterSuccess.bind { success in
            
            print("success====>", success)
            
            if success {
                // self.navigates(to: .home(.push(subtype: .fromLeft)))
                self.navigates(to: .OTP)

            }
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        //        navigates(to: .home(.push(subtype: .fromLeft)))
        //        navigates(to: .OTP)
        //        validate()
        
//        APIClient.uploadss(image: UIImage(named: "aeon.rohas")!) { (result) in
//            print("Result.......", result)
//        }
        
        
        
        viewModel.fetchRSA { (result) in
            let publicKey = result.body.data?.publicKey
            
            //let plainText = "abcdefg".toBase64()
            
            let sha256 = String.random(length: 5).asSha256 // randomsha
            Preference.sha256 = sha256
            
            
            
            let encrypted = RSA.encrypt(string: sha256, publicKey: publicKey)
            
            print("public Key===>", publicKey )
            print("Random sha===>", sha256)
            print("Blank sha===>", "".asSha256)
            
            
            
//            print(encrypted, sha256, String.random(), "".asSha256)
            
            
            
            self.viewModel.submitAES(encryption: encrypted!) {
//                self.viewModel.register(with: Param.Register(username: "Dara", phone: "095344527", email: "abc@gmail.com", password: "123"))
//                self.viewModel.register2()
                
                
                Upload().upload(image: UIImage(named: "AEONSPB-logo.png")!) { (progress) in
                    print("Progress", progress)
                } completion: { (completed) in
                    print("Upload completed", completed)
                }
            }
            
        }
        
        print("shar256", String.random(length: 5) )
        
        
        // 1. get publickey (onetime)
        // 2.encrypt
        //  - store shar
        //  - send encrypted to sever
        // 3. 
    }
    
    @IBAction func passwordEyeballTapped(_ sender: Any) {
        showPassword(at: 0)
    }
    
    @IBAction func confirmPasswordEyeballTapped(_ sender: Any) {
        showPassword(at: 1)
    }
    
    func showPassword(at index: Int) {
        secured = !secured
        let eyeball = UIImage(systemName: secured ? "eye.slash" : "eye")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        let passwordFields = [passwordTextField, confirmPasswordTextField]
        eyeballButtons[index].setImage(eyeball, for: .normal)
        passwordFields[index]?.isSecureTextEntry = secured
    }
    
    func navigateToHome() {
        //        let login = HomeView.instantiate()
        //        let controller = NavigationController.blue(with: login)
        //        self.present(login, animated: true, completion: {})
    }
    
    private func setupView(){
        setup(title: NSLocalizedString("Register", comment: ""))
        setupTextField()
        registerButton.rounds(radius: 10, background: .brandPurple, border: .brandPurple, width: 1)
    }
    
    func setupTextField() {
        let textFields = [usernameTextField, phoneTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        let placeholders = ["Username", "Phone Number", "Email Adress", "Password", "Confirm Password"]
        let eyeball = UIImage(systemName: "eye.slash")?.withTintColor(.brandGray, renderingMode: .alwaysOriginal)
        
        for (index, field) in textFields.enumerated() {
            field?.placeholder = NSLocalizedString(placeholders[index], comment: "")
        }
        
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        eyeballButtons.forEach { $0.setImage(eyeball, for: .normal) }
        textFields.forEach { $0?.autocorrectionType = .no}
    }
    
    func validate() {
        do {
            let username = try usernameTextField.validatedText(type: .username)
            let phone = try phoneTextField.validatedText(type: .phone)
            let email = try emailTextField.validatedText(type: .email)
            let password = try passwordTextField.validatedText(type: .password)
            let confirm = try confirmPasswordTextField.validatedText(type: .password)
            
            guard password == confirm else {
                showAlert(message: "Password Mismatched")
                return
            }
            
            //let data = Param.Register(username: username, phoneNumber: phone, email: email, password: password)
            //fetch(with: data)
        } catch (let error) {
            showAlert(message: (error as! ValidationError).message)
        }
    }
    
    func fetch(with param: Param.Register) {
        viewModel.register(with: param)
        
        //        viewModel.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        //        showAlert(title: "Success", message: "Hello World", buttonTitle: "Try again")
    }
}



//extension String {
//
//    func sha256() -> String{
//        if let stringData = self.data(using: String.Encoding.utf8) {
//            return hexStringFromData(input: digest(input: stringData as NSData))
//        }
//        return ""
//    }
//
//    private func digest(input : NSData) -> NSData {
//        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//        var hash = [UInt8](repeating: 0, count: digestLength)
//        CC_SHA256(input.bytes, UInt32(input.length), &hash)
//        return NSData(bytes: hash, length: digestLength)
//    }
//
//    private  func hexStringFromData(input: NSData) -> String {
//        var bytes = [UInt8](repeating: 0, count: input.length)
//        input.getBytes(&bytes, length: input.length)
//
//        var hexString = ""
//        for byte in bytes {
//            hexString += String(format:"%02x", UInt8(byte))
//        }
//
//        return hexString
//    }
//
//}

extension String {
    var asSha256: String {
//        let sha = SHA256.hash(data: self.asData )
        
//        let digest = SHA256.hash(data: self.asData).
        let hash = SHA256.hash(data: self.asData)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    
    }
    
    static func random(length: Int = 5) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}


