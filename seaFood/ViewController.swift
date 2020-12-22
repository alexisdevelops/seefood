//
//  ViewController.swift
//  seaFood
//
//  Created by alexis on 17/12/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {


    
    @IBOutlet weak var resultingImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userSnapshot = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            resultingImageView.image = userSnapshot
            guard let ciimage = CIImage(image: userSnapshot) else {
                fatalError("UIImage userSnapshot could not be converted into a CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("userSnapshot could not be converted into a CIImage")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Results could not be parsed into VNClassificationObservations")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hot dog"
                } else {
                    self.navigationItem.title = "Not a Hot dog"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }

    
    
    
    @IBAction func camaraButtonPressed(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true) {
            return
        }
    }
}

