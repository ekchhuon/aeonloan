//
//  PhotoViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/23/20.
//

import UIKit
import AVFoundation
import Vision
import ImageIO

extension PhotoViewController {
    static func instantiate() -> PhotoViewController {
        return PhotoViewController()
    }
}

class PhotoViewController: BaseViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var mrzScannerView: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isFront: Bool = false
    
    var attributeViews = [UIView]()
    var images = [UIImage]()
    
    lazy var instructionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.setHeight(200)
        view.setWidth(200)
        return view
    }()
    
    lazy var hint1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is label view.11111"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hint2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is label view.22222"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var checkmark1: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode:.alwaysOriginal)
        imgView.setWidth(20)
        imgView.setHeight(20)
        return imgView
    }()
    
    var checkmark2: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode:.alwaysOriginal)
        imgView.setWidth(20)
        imgView.setHeight(20)
        return imgView
    }()
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: Resnet50().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hint1Label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget libero a arcu feugiat malesuada ut ut lectus. Nunc pharetra"
        hint2Label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget libero a arcu feugiat malesuada ut ut lectus. Nunc pharetra"
        
        attributeViews = [checkmark1, checkmark2, hint1Label, hint2Label]
        setAttributes(camera: .back, title: "Take a photo of ID or Passport")
        setupSwipeGestureRecognizerOnCollection()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera(with: .back)
    }
    
    
    @IBAction func StartScan(sender: AnyObject) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let scanVC: MyScanViewController = storyboard.instantiateViewControllerWithIdentifier("PassportScanner") as! MyScanViewController
//        scanVC.delegate = self
//        self.presentViewController(scanVC, animated: true, completion: nil)
    }
    
    // gesture
    private func setupSwipeGestureRecognizerOnCollection() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc
    private func handleGesture(gesture: UISwipeGestureRecognizer) {
        print(gesture.direction)

        if gesture.direction == .right {
            self.instructionView.slideOut()
            self.instructionView.fadeOut()
        } else if gesture.direction == .left {
            self.instructionView.slideIn()
            self.instructionView.fadeIn()
        }
    }
    
    @IBAction func switchTapped(_ sender: Any) {
        isFront = !isFront
        setupCamera(with: isFront ? .front : .back)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isFront {
                self.setAttributes(camera: .front, title: "Selfie", subtitle: "")
            } else {
                self.setAttributes(camera: .back, title: "Take a photo of ID or Passport")
            }
        }
    }
    
    private func setAttributes(camera position: AVCaptureDevice.Position, title: String = "", subtitle: String = "") {
        titleLabel.text = NSLocalizedString(title, comment: "")
        subtitleLabel.text = NSLocalizedString(subtitle, comment: "")
        //        attributeViews.forEach { $0.isHidden = position == .back }
        attributeViews.forEach { position == .back ? $0.fadeOut() : $0.fadeIn() }
    }
    
    func setupCamera(with position: AVCaptureDevice.Position) {
        // Setup camera...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("Unable to access camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        // add subviews
        previewView.addSubview(instructionView)
        instructionView.setLeft(equalTo: previewView.leftAnchor, constant: 0)
        instructionView.setRight(equalTo: previewView.rightAnchor, constant: 0)
        instructionView.setBottom(qualTo: previewView.bottomAnchor, constant: 0)
         
        instructionView.addSubViews([checkmark1, checkmark2, hint1Label, hint2Label])
        hint2Label.setLeft(equalTo: instructionView.leftAnchor, constant: 40)
        hint2Label.setBottom(qualTo: instructionView.bottomAnchor, constant: -20)
        hint2Label.setRight(equalTo: instructionView.rightAnchor, constant: -20)
        hint1Label.setLeft(equalTo: instructionView.leftAnchor, constant: 40)
        hint1Label.setBottom(qualTo: hint2Label.topAnchor, constant: -20)
        hint1Label.setRight(equalTo: instructionView.rightAnchor, constant: -20)
        checkmark2.centers(.vertically(.left), to: hint2Label, constant: -10)
        checkmark1.centers(.vertically(.left), to: hint1Label, constant: -10)
        // ..
        
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        let image = UIImage(data: imageData)
        capturedImageView.image = image
        print("Image size \(image?.getSizeIn(.megabyte)) mb")
        guard let img = image else {return}
//        classifyImage(img)
        updateClassifications(for: img)
    }
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        titleLabel.text = "Classifying..."
        
        guard let orientation = CGImagePropertyOrientation(
          rawValue: UInt32(image.imageOrientation.rawValue)) else {
          return
        }
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.titleLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.titleLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.titleLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
    
    func f() {
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}

        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//            self?.processClassifications(for: request, error: error)

            guard let result = request.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = result.first else {return}

            print(firstObservation.identifier, firstObservation.confidence)


        })
//        request.imageCropAndScaleOption = .centerCrop
//        return request
        
        // VNImageRequestHandler(cvPixelBuffer: <#T##CVPixelBuffer#>, options: <#T##[VNImageOption : Any]#>)
        
    }
    
//    func vnRequest() {
//        let aaa = VNImageRequestHandler
//    }

}


extension UIView {
    func fadeTo(_ alpha: CGFloat, duration: TimeInterval = 0.3) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.alpha = alpha
            }
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3) {
        fadeTo(1.0, duration: duration)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3) {
        fadeTo(0.0, duration: duration)
    }
    
    func slide(x: CGFloat = 0, y: CGFloat = 0) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(translationX: x, y: y)
            }, completion: nil)
        }
    }
    
    func slideIn() {
        slide(x: 0, y: 0)
    }
    
    func slideOut() {
        slide(x: self.bounds.width, y: 0)
    }
}



