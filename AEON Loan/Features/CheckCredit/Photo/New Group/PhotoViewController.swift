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
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var loading: UILabel!
    
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    lazy var myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is label view."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.backgroundColor = .red
        //        label.frame.size.height = 100
        //        label.frame.size.width = 300
        
        
        return label
    }()
    
    var myView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        //        view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        return view
    }()
    
    var checkmark1UIImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode:.alwaysOriginal)
        return imgView
    }()
    
    var checkmark2UIImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode:.alwaysOriginal)
        return imgView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        preview.add(checkmark1UIImageView, left: 10, right: -10, top: 10, bottom: -10)
        preview.add(myLabel, left: (preview.leftAnchor, 10), right: (preview.rightAnchor, -10), top: (preview.topAnchor, 10), bottom: (preview.bottomAnchor, -10))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        
        captureSession.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
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
        preview.layer.addSublayer(videoPreviewLayer)
        //        preview.addSubview(myLabel)
        preview.addSubview(loading)
        //        myLabel.widthAnchor.constraint(equalToConstant:  200).isActive = true
        //        myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //        preview.add2(myLabel, .left(20, view.rightAnchor), .right(30, view.rightAnchor), .top(40, view.leftAnchor), .buttom(20, view.leftAnchor), abc: <#(String, Int)#>)
        
        //        preview.centers(myLabel)
        
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.preview.bounds
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

extension UIImage {
    
    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }
    
    func getSizeIn(_ type: DataUnits)-> String {
        
        guard let data = self.pngData() else {
            return ""
        }
        
        var size: Double = 0.0
        
        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        
        return String(format: "%.2f", size)
    }
}
