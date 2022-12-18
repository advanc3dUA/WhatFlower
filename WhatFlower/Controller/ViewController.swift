//
//  ViewController.swift
//  WhatFlower
//
//  Created by Yuriy Gudimov on 08.12.2022.
//

import UIKit
import CreateML
import Vision
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var imagePickerController = UIImagePickerController()
    private var flowerLogic = FlowerLogic()
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerController()
        self.title = "What is this flower?"
    }
    
    
    fileprivate func setupImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera
    }
    
    @IBAction func takePhotoPressed(_ sender: UIBarButtonItem) {
        present(imagePickerController, animated: true)
    }
    
    func detect(image: CIImage) {
        let mlModelConfiguration = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: mlModelConfiguration).model) else {
            fatalError("Error creating while creating a model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Couldn't get result, the error is: \(error!)")
            }
            
            if let firstResult = result.first?.identifier {
                var modifiedResult = firstResult.capitalized
                
                // Removing of ' from the identifier
                modifiedResult.removeAll { $0 == "'" }
                
                // Removing space from the start of identifier
                modifiedResult.remove(at: modifiedResult.startIndex)

                self.title = modifiedResult
                
                // Core logic of the app execution
                self.flowerLogic.requestInfo(for: modifiedResult) { description, flowerURLString in
                    DispatchQueue.main.async {
                        if flowerURLString != nil {
                            self.photoImageView.sd_setImage(with: URL(string: flowerURLString!))
                        }
                        self.descriptionTextView.text = description
                    }
                }
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
