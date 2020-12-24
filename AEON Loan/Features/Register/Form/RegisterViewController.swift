//
//  RegisterViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/8/20.
//

import UIKit

extension RegisterViewController {
    static func instantiate(with data: UserAsset) -> RegisterViewController {
        let controller = RegisterViewController()
        controller.asset = data
        return controller
    }
}

class RegisterViewController: BaseViewController {
    private let viewModel = RegisterViewModel()
    private let loginViewModel = LoginViewModel()
    private var asset = UserAsset()
    
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
        
        print("User Asset", asset)
        usernameTextField.text = asset.holderName
    }
    
    private func bind() {
        viewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        viewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Register".localized ,message: msg)
        }
        viewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Register".localized, message: err.localized)
        }
        
        loginViewModel.status.bind { [weak self] status in
            guard let self = self else { return }
            self.showIndicator(status == .started)
        }
        loginViewModel.message.bind { [weak self] msg in
            guard let self = self, let msg = msg else { return }
            self.showAlert(title: "Register".localized ,message: msg)
        }
        loginViewModel.error.bind { [weak self] (err) in
            guard let self = self, let err = err else { return }
            self.showAlert(title: "Register".localized, message: err.localized)
        }
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        //        let documents = [UploadAPIRouter.profile: "banner.aeon.installment", UploadAPIRouter.profile: "aeon.rohas"]
        //
        //        for (k,v) in documents {
        //
        //        }
        
        guard let selfieImage = self.asset.selfieImage,
              let scannedImage = self.asset.documentImage else {
            debugPrint("Image not found!")
            return
        }
        
        validate { user in
            self.loginViewModel.requestAuth {
                print("1...requestAuth")
                self.viewModel.register(user: user) { user in
                    print("2...register")

                    self.viewModel.upload(.profile, image: selfieImage) { progress in
                        
                        print("uploading profile...", progress)
                        //                    let indicator = self.showIndicator(true)
                        //                    indicator.mode = .annularDeterminate
                        //                    indicator.progress = progress
                        
                    } completion: { _ in
                        print("3...upload profile")
                        self.viewModel.upload(.document, image: scannedImage) { progress in
                            print("uploading docs...", progress)
                        } completion: { _ in
                            print("4...upload docs.")
                            self.navigates(to: .OTP(with: user))
                        }
                    }
                }
            }
        }
        
        /*
         self.loginViewModel.requestAuth {
         print("1...requestAuth")
         self.viewModel.register { user in
         print("2...register")
         self.viewModel.upload(.profile ,image: UIImage(named: "banner.aeon.installment")!) { (progress) in
         
         } completion: { (result) in
         print("3...upload profile")
         self.viewModel.upload(.document ,image: UIImage(named: "aeon.rohas")!) { (progress) in
         
         } completion: { (result) in
         print("4...upload document")
         self.navigates(to: .OTP(with: user))
         }
         }
         }
         }
         */
        
        /*
         
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
         self.showLoadingIndicator()
         self.viewModel.submitAES(encryption: encrypted!) {
         self.viewModel.upload(image: UIImage(named: "banner.aeon.installment")!) { (progress) in
         
         
         } completion: { (result) in
         print("result===>",result)
         self.hideLoadingIndicator()
         
         //self.navigates(to: .OTP)
         
         self.viewModel.register2()
         
         }
         
         //                Upload().upload(route: .profile, image: UIImage(named: "AEONSPB-logo.png")!) { (progress) in
         //                    print("Progress", progress)
         //                } completion: { (completed) in
         //                    print("Upload completed", completed)
         //                }
         }
         
         }
         
         print("shar256", String.random(length: 5) )
         
         
         // 1. get publickey (onetime)
         // 2.encrypt
         //  - store shar
         //  - send encrypted to sever
         // 3.
         */
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
    
    func validate(completion: @escaping (_ data: User) -> Void) {
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
            
            let user = User(username: username, phoneNumber: phone, email: email, password: password, idPhoto: "", nidPassport: "")
            completion(user)
        } catch (let error) {
            showAlert(message: (error as! ValidationError).message)
        }
    }
    
    func fetch(with param: Param.Register) {
        
    }
}




