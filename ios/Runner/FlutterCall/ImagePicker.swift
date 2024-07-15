//
//  ImagePicker.swift
//  Runner
//
//  Created by Winter Not Exist on 12/07/2024.
//

import Foundation


class ImagePicker: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var flutterResult: FlutterResult?
    private var controller: FlutterViewController?
    
    init(controller: FlutterViewController? = nil) {
        self.controller = controller
    }
    
    func pickImage(result: @escaping FlutterResult) {
        flutterResult = result
        showImagePicker()
    }
    
    private func showImagePicker() {
            guard let controller = controller else {
                flutterResult?(FlutterError(code: "ERROR", message: "Controller not available", details: nil))
                return
            }

            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            controller.present(imagePicker, animated: true, completion: nil)
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            flutterResult?(FlutterError(code: "ERROR", message: "Image not found", details: nil))
            return
        }
        guard let imageData = image.pngData() else {
            flutterResult?(FlutterError(code: "ERROR", message: "Could not convert image", details: nil))
            return
        }
        flutterResult?(imageData)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        flutterResult?(FlutterError(code: "CANCELLED", message: "Image picker cancelled", details: nil))
    }
}
