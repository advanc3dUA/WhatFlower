//
//  ViewController.swift
//  WhatFlower
//
//  Created by Yuriy Gudimov on 08.12.2022.
//

import UIKit
import CreateML
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    private var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerController()
        self.title = "What Flower?"
    }
    
    
    fileprivate func setupImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera
    }
    
    @IBAction func takePhotoPressed(_ sender: UIBarButtonItem) {
        present(imagePickerController, animated: true)
    }
    
    private func detect(image: CIImage) {
        let mlModelConfiguration = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: mlModelConfiguration).model) else {
            fatalError("Error creating while creating a model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Couldn't get result, the error is: \(error!)")
            }
            
            if let firstResult = result.first?.identifier {
                self.title = firstResult.capitalized
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoImageView.image = selectedImage
            
            guard let ciImage = CIImage(image: selectedImage) else {
                fatalError("Error creating ciImage from UIImage")
            }
            
            detect(image: ciImage)
            imagePickerController.dismiss(animated: true)
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}
