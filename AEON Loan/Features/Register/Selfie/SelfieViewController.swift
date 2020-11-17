//
//  SelfieViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import UIKit
import AVFoundation
import Vision

extension SelfieViewController {
    static func instantiate() -> SelfieViewController {
        return SelfieViewController()
    }
}

class SelfieViewController: BaseViewController, AVCapturePhotoCaptureDelegate {
    private let viewModel = SelfieViewModel()
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var checkmarkImageVIew: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
    var activityCompenentViews: [UIView]!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isCaptured: Bool = false
    
    var capturedImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode:.alwaysOriginal)
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    //
    lazy var faceDetectionRequest: VNDetectFaceRectanglesRequest = {
        let faceLandmarksRequest = VNDetectFaceRectanglesRequest(completionHandler: { [weak self] request, error in
            self?.handleDetection(request: request, errror: error)
        })
        return faceLandmarksRequest
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading(started: false)
        checkmarkImageVIew.isHidden = true
        subtitleLabel.isHidden = true
        updateActionButton(selfie: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCameraSession(with: .front)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    fileprivate func validateSelfie(with observation: [VNFaceObservation]) {
        let isValid = observation.count == 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading(started: false)
            self.checkmarkImageVIew.isHidden = !isValid
            self.subtitleLabel.isHidden = isValid
            self.updateActionButton(selfie: isValid)
            //            self.updateCaptureButton(selfie: isValid)
            if isValid {
                self.titleLabel.text = "Awesome"
                self.checkmarkImageVIew.isHidden = false
            } else {
                self.titleLabel.text = "Please try again!"
                self.subtitleLabel.text = "Please remove any accessories that covers your face."
            }
        }
    }
    
    func setupCapturedImage(_ image: UIImage) {
        previewView.addSubview(capturedImageView)
        capturedImageView.setLeft(equalTo: previewView.leftAnchor, constant: 0)
        capturedImageView.setRight(equalTo: previewView.rightAnchor, constant: 0)
        capturedImageView.setTop(equalTo: previewView.topAnchor, constant: 0)
        capturedImageView.setBottom(qualTo: previewView.bottomAnchor, constant: 0)
        capturedImageView.image = image
    }
    
    fileprivate func updateCaptureButton(selfie isValid: Bool) {
        let buttonIcon = isCaptured && isValid ? "camera.snap" : "camera.refresh.fill"
        
        self.captureButton.setImage(UIImage(named: buttonIcon), for: .normal)
    }
    
    fileprivate func updateActionButton(selfie isValid: Bool) {
        captureButton.isHidden = isValid
        retakeButton.isHidden = !isValid
        continueButton.isUserInteractionEnabled = isValid
        continueButton.alpha = isValid ? 1:0.5
    }
    
    
    @IBAction func captureButtonTapped(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera is not avaiable")
            return
        }
        isCaptured ? capturedImageView.removeFromSuperview() : startCapture()
        isCaptured = !isCaptured
    }
    
    @IBAction func retakeLibrary(_ sender: Any) {
        capturedImageView.removeFromSuperview()
        updateActionButton(selfie: false)
        isCaptured = !isCaptured
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        capturedImageView.removeFromSuperview()
    }
}

// Materials
extension SelfieViewController {
    fileprivate func loading(started: Bool) {
        indicatorView.isHidden = !started
        indicatorView.startAnimating()
    }
}

// Custom Camera
extension SelfieViewController {
    
    func startCapture() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func setupCameraSession(with position: AVCaptureDevice.Position) {
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
        
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {return}
            self.captureSession.startRunning()
            //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        let image = UIImage(data: imageData)
        capturedImageView.image = image
        print("Image size \(image?.getSizeIn(.megabyte)) mb")
        guard let img = image else {return}
        // classifyImage(for: img)
        guard let croped = img.crop(to: videoPreviewLayer) else {
            print("Unable to crop image")
            return
        }
        setupCapturedImage(croped.flip(.leftMirrored))
        launchDetection(image: croped)
    }
}

// MARK: - Face Recognition
extension SelfieViewController  {
    
    fileprivate func launchDetection(image: UIImage) {
        loading(started: true)
        titleLabel.text = "Verifying..."
        checkmarkImageVIew.isHidden = true
        subtitleLabel.isHidden = true
        let orientation = image.coreOrientation()
        guard let coreImage = CIImage(image: image) else { return }
        DispatchQueue.global().async {
            let handler = VNImageRequestHandler(ciImage: coreImage, orientation: orientation)
            do {
                try handler.perform([self.faceDetectionRequest])
            } catch {
                print("Failed to perform detection .\n\(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func handleDetection(request: VNRequest, errror: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let observations = request.results as? [VNFaceObservation] else {
                fatalError("unexpected result type!")
            }
            print("Detected \(observations.count) faces")
            self?.validateSelfie(with: observations)
            // observations.forEach( { self?.addFaceRecognitionLayer($0) })
        }
    }
}

extension UIImage {
    
    func coreOrientation() -> CGImagePropertyOrientation {
        switch imageOrientation {
        case .up : return .up
        case .upMirrored: return .upMirrored
        case .down: return .down // 0th row at bottom, 0th column on right  - 180 deg rotation
        case .downMirrored : return .downMirrored// 0th row at bottom, 0th column on left   - vertical flip
        case .leftMirrored : return .leftMirrored // 0th row on left,   0th column at top
        case .right : return .right // 0th row on right,  0th column at top    - 90 deg CW
        case .rightMirrored : return .rightMirrored // 0th row on right,  0th column on bottom
        case .left : return .left // 0th row on left,   0th column at bottom - 90 deg CCW
        }
    }
}

extension UIImage {
    func flip(_ orientation: Orientation) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: orientation)
    }
}
