//
//  ScanViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/30/20.
//

import UIKit
import Vision
import VisionKit

extension ScanViewController {
    static func instantiate() -> ScanViewController {
        return ScanViewController()
    }
}

class ScanViewController: UIViewController {
    @IBOutlet weak var scannedImage: UIImageView!
    @IBOutlet weak var docsIdentifierLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet var instructionView: [UIView]!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var recognizedText = ""
    var recognizedTexts = [String]()
    var textRecognitionRequest = VNRecognizeTextRequest()
    let validator = DocumentValidator()
    var moved: Bool = false
    var docsIdentifierViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeRequest()
        checkmarkImageView.isHidden = true
        docsIdentifierViews = [docsIdentifierLabel, checkmarkImageView]
        docsIdentifierViews.forEach { $0.isHidden = true }
        disableContinueButton(disabled: false)
    }
    
    private func validate(_ recognizedTexts: [String]) {
        show(indicator: true)
        docsIdentifierViews.forEach { $0.isHidden = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.show(indicator: false)
            self.docsIdentifierViews.forEach { $0.isHidden = false }
        }
        
        validator.recognizedTexts = recognizedTexts
        let result = validator.validate()
        
        docsIdentifierLabel.text = result.identifier
        checkmarkImageView.image = UIImage(systemName: result == .unknown ? "xmark.circle.fill" : "checkmark.circle.fill")
        checkmarkImageView.tintColor = result == .unknown ? .red : .systemGreen
        
        print("result", recognizedTexts)
        
        //disableContinueButton(disabled: result == .unknown)
    }
    
    fileprivate func disableContinueButton(disabled: Bool) {
            continueButton.isUserInteractionEnabled = !disabled
            continueButton.alpha = disabled ? 0.5 : 1
    }
    
    func recognizeRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.recognizedText = ""
                    self.recognizedTexts = []
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidiate.string
                        self.recognizedText += "\n"
                        self.recognizedTexts.append(candidiate.string)
                    }
                    
                    //self.textView.text = "1.=====\(requestResults) \n\n2. \(self.recognizedText) \n\n3.\(self.recognizedTexts)"
                    self.validate(self.recognizedTexts)
                }
            } else {
                self.show(indicator: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.show(indicator: false)
                    self.showAlert(message: "Invalid")
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    fileprivate func handleTextRecognition(with image: UIImage) {
        scannedImage.image = image
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    func openScanner() {
        // Use VisionKit to scan business document
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let controller = ScanInstructionViewController.instantiate()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        openScanner()
    }
}

extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        handleTextRecognition(with: image)
        instructionView.forEach { $0.isHidden = true }
    }
}

// MARK: Scanner
extension ScanViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        handleTextRecognition(with: image)
        instructionView.forEach { $0.isHidden = true }
        controller.dismiss(animated: true)
    }
}

extension Array where Element == String {
    func getIDInfo() -> [String] {
        let id = self.findDigit(of: 9)[0]
        let name = self[2]
        return [id, name]
    }
}




