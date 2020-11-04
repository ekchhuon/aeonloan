//
//  PhotoViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/23/20.
//

import UIKit
import AVFoundation

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
    
    lazy var myView: UIView = {
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
    
//     var supportedInterfaceOrientations: UIInterfaceOrientationMask
//     var prefersStatusBarHidden: Bool
    
    
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
            self.myView.slideOut()
            self.myView.fadeOut()
        } else if gesture.direction == .left {
            self.myView.slideIn()
            self.myView.fadeIn()
        }
        
    }
    
    @IBAction func switchTapped(_ sender: Any) {
        isFront = !isFront
        setupCamera(with: isFront ? .front : .back)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isFront {
                self.setAttributes(camera: .front, title: "Selfie", subtitle: "Please take selfie to help us confirm your identity")
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
        previewView.addSubview(myView)
        myView.setLeft(equalTo: previewView.leftAnchor, constant: 0)
        myView.setRight(equalTo: previewView.rightAnchor, constant: 0)
        myView.setBottom(qualTo: previewView.bottomAnchor, constant: 0)
         
        myView.addSubViews([checkmark1, checkmark2, hint1Label, hint2Label])
        hint2Label.setLeft(equalTo: myView.leftAnchor, constant: 40)
        hint2Label.setBottom(qualTo: myView.bottomAnchor, constant: -20)
        hint2Label.setRight(equalTo: myView.rightAnchor, constant: -20)
        hint1Label.setLeft(equalTo: myView.leftAnchor, constant: 40)
        hint1Label.setBottom(qualTo: hint2Label.topAnchor, constant: -20)
        hint1Label.setRight(equalTo: myView.rightAnchor, constant: -20)
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
    }
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





