//
//  TakePhotoViewController.swift
//  AEON Loan
//
//  Created by aeon on 9/21/20.
//

import UIKit

extension TakePhotoViewController {
    static func instantiate() -> TakePhotoViewController {
        return TakePhotoViewController()
    }
}

class TakePhotoViewController: BaseViewController, UINavigationControllerDelegate {
    private let viewModel = TakePhotoViewModel()
    
    @IBOutlet weak var takenImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case library
        case camera
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.rounds(radius: 10, background: .brandPurple)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Saving Image here
    @IBAction func take(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.library)
            return
        }
        selectImageFrom(.camera)
    }
    
//    func showAlertWith(title: String, message: String){
//        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
//
//    //MARK: - Add image to Library
//    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            // we got back an error!
//            showAlertWith(title: "Save error", message: error.localizedDescription)
//        }  else {
//            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
//        }
//    }
//
//    //MARK: - Saving Image here
//    @IBAction func save(_ sender: AnyObject) {
//        guard let selectedImage = takenImage.image else {
//            print("Image not found!")
//            showAlertWith(title: "", message: "No Image found")
//            return
//        }
//        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//
//
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .library:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)  
    }
    
    //MARK: - Next Tapped
    @IBAction func next(_ sender: Any) {
        navigates(to: .selfie)
//        let controller = PhotoViewController.instantiate()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension TakePhotoViewController: UIImagePickerControllerDelegate{

   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
       imagePicker.dismiss(animated: true, completion: nil)
       guard let selectedImage = info[.originalImage] as? UIImage else {
           print("Image not found!")
           return
       }
       takenImage.image = selectedImage
   }
}


