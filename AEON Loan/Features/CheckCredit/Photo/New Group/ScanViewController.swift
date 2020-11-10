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
    @IBOutlet weak var regconizedTextLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var scannerBarView: UIView!
    var recognizedText = ""
    var recognizedTexts = [String]()
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    var moved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        recognizeRequest()
    }
    
    private func validateDocs(_ recognizedTexts: [String]) {
        
        
        let itemsArray = ["Google", "Goodbye", "Go", "Hello"]

        var filterdItemsArray = [String]()
        let searchText = "go"

        filterdItemsArray = itemsArray.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }

//        print(filterdItemsArray)
//        textView.text = "\(filterdItemsArray) \(itemsArray)"
        
        let aaa = recognizedTexts.find(item: "idkhm")
        textView.text = "\(aaa), ID: \(recognizedTexts[1]) Name: \(recognizedTexts[2])"
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
                    
                    
                    self.textView.text = "1.=====\(requestResults) \n\n2. \(self.recognizedText) \n\n3.\(self.recognizedTexts)" //self.recognizedText
                    // self.showAlert(message: "\(requestResults)")
                    
                    self.validateDocs(self.recognizedTexts)
                    
                    
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
        // presentPhotoPicker(sourceType: .photoLibrary)
        
        self.moved = !self.moved
        
        scannerBarView.slide(x: moved ? 0: self.view.bounds.width, y: 0, duration: 0.5)
        
        moved ? scannedImage.displayAnimatedActivityIndicatorView() : scannedImage.hideAnimatedActivityIndicatorView()
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.scannerBarView.slideIn()
//        }
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
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        readImage(image: image)
        //imageView.image = image
        //updateClassifications(for: image)
    }
}

extension ScanViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        readImage(image: image)
        controller.dismiss(animated: true)
    }
}


enum DocumentType{
    case nId(Nationality)
    case passport(Nationality)
    
    enum Nationality {
        case local
        case outsider
    }
    
//    var identifier: [String] {
//        switch self {
//        case .nId(.local):
//            return ["idkhm", "id", "khm"]
//        default:
//            <#code#>
//        }
//    }
}


extension Array where Element == String {
    // find words/chars in string array
    func find(items searchingItems: [String]) -> [String] {
        let finderSet:Set<String> = Set(searchingItems)
        let filteredArray = self.filter {
            return Set($0.lowercased().map({String($0.lowercased())})).intersection(finderSet).count == searchingItems.count
        }
        return filteredArray
    }
    
    // find a word/char in string array
    func find(item searchingItem: String) -> [String] {
        let matched = self.filter {
            return $0.lowercased().contains(searchingItem.lowercased())
        }
        return matched
    }
}
