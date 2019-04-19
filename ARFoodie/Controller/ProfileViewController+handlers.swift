//
//  ProfileViewController+handlers.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Firebase

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func profileImageViewSelectHandler() {

        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = true

        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        var selectImage: UIImage?

        if let editedImage = info[.editedImage] as? UIImage {
            selectImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectImage = originalImage
        }

        self.profileImageView.image = selectImage

        
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Did cancel picker view")
        self.dismiss(animated: true, completion: nil)
    }
}
