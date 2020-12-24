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
    @IBOutlet weak var recognitionLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var instructionView: [UIView]!
    @IBOutlet weak var continueButton: UIButton!
    
    
//    var recognizedText = ""
    var recognizedTexts = [String]()
    var textRecognitionRequest = VNRecognizeTextRequest()
    let validator = DocumentValidator()
    var moved: Bool = false
    //var docsIdentifierViews: [UIView]!
    var asset = UserAsset()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeRequest()
        checkmarkImageView.isHidden = true
        [recognitionLabel, checkmarkImageView].forEach { $0.isHidden = true }
        disableContinueButton(disabled: false)
        loading(started: false)
    }
    
    fileprivate func loading(started: Bool) {
        indicatorView.isHidden = !started
        indicatorView.startAnimating()
    }
    
    private func validate(_ recognizedTexts: [String]) {
        validator.recognizedTexts = recognizedTexts
        let document = validator.validate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loading(started: false)
            self.recognitionLabel.text = "\(document.description)"
            self.checkmarkImageView.isHidden = (document == .unknown)
            //disableContinueButton(disabled: result == .unknown)
        }
        
        print("result", recognizedTexts.getIdNumber(from: document))
        print("result", recognizedTexts.getHolderName(from: document))
        
        guard let documentID = recognizedTexts.getIdNumber(from: document) else {
            showAlt(title: "Please try again!", message: "Loream ipsum dolor sit amert", style: .alert); return
        }
        
        asset.documentID = documentID
        asset.holderName = recognizedTexts.getHolderName(from: document)
        asset.documentType = document
    }
    
    fileprivate func disableContinueButton(disabled: Bool) {
            continueButton.isUserInteractionEnabled = !disabled
            continueButton.alpha = disabled ? 0.5 : 1
    }
    
    func recognizeRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    //self.recognizedText = ""
                    self.recognizedTexts = []
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
//                        self.recognizedText += candidiate.string
//                        self.recognizedText += "\n"
                        self.recognizedTexts.append(candidiate.string)
                    }
                    
                    //self.textView.text = "1.=====\(requestResults) \n\n2. \(self.recognizedText) \n\n3.\(self.recognizedTexts)"
                    print("Document: ", self.recognizedTexts)
                    self.validate(self.recognizedTexts)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.recognitionLabel.text = "Invalid"
                    self.loading(started: false)
                }
                return
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
        recognitionLabel.isHidden = false
        recognitionLabel.text = "Identifying..."
        checkmarkImageView.isHidden = true
        loading(started: true)
        
        scannedImage.image = image
        asset.documentImage = image
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
        let controller = SelfieInstructionViewController.instantiate(with: asset)
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
//    func getIDInfo() -> [String] {
//        let id = self.findDigit(of: 9)[0]
//        let name = self[2]
//        return [id, name]
//    }
}


struct UserAsset {
    var documentID: String
    var holderName: String
    var documentType: DocumentType
    var documentImage: UIImage?
    var selfieImage: UIImage?
    
    init(documentID: String = "", holderName: String = "", documentType: DocumentType = .unknown , documentImage: UIImage? = nil, selfieImage: UIImage? = nil) {
        self.documentID = documentID
        self.holderName = holderName
        self.documentType = documentType
        self.documentImage = documentImage
        self.selfieImage = selfieImage
    }
}
