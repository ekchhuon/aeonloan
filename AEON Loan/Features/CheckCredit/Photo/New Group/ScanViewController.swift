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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    
    
    var recognizedText = ""
    var recognizedTexts = [String]()
    var textRecognitionRequest = VNRecognizeTextRequest()
    let document = DocumentValidator()
    var moved: Bool = false
    var docsIdentifierViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeRequest()
        checkmarkImageView.isHidden = true
        docsIdentifierViews = [docsIdentifierLabel, checkmarkImageView]
        docsIdentifierViews.forEach { $0.isHidden = true }
    }
    
    private func validate(_ recognizedTexts: [String]) {
        show(indicator: true)
        docsIdentifierViews.forEach { $0.isHidden = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.show(indicator: false)
            self.docsIdentifierViews.forEach { $0.isHidden = false }
        }
        
        document.recognizedTexts = recognizedTexts
        let result = document.validate()
        
        docsIdentifierLabel.text = result.identifier
        checkmarkImageView.image = UIImage(systemName: result == .unknown ? "xmark.circle.fill" : "checkmark.circle.fill")
        checkmarkImageView.tintColor = result == .unknown ? .red : .systemGreen
        
        print("result", recognizedTexts)
        
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
                print("Unknow")
                self.showAlert(message: "Invalid")
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
    
    func readImage(image: UIImage) {
        scannedImage.image = image
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        // Use VisionKit to scan business cards
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true, completion: nil)
    }
}

extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        readImage(image: image)
    }
}

// MARK: Scanner
extension ScanViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        readImage(image: image)
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




