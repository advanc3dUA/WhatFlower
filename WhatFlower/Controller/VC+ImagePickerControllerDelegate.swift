//
//  VC+ImagePickerControllerDelegate.swift
//  WhatFlower
//
//  Created by Yuriy Gudimov on 11.12.2022.
//

import UIKit

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
