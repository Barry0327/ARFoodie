//
//  UIViewControllerExtension.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notifiction: Notification) {
        guard
            let keybroadFrame = notifiction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keybroadFrame.cgRectValue.height
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardHeight - 60
        }
    }

    @objc func keyboardWillHide(notificiton: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
