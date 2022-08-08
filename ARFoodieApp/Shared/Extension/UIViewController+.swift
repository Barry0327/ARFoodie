//
//  UIViewControllerExtension.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
// MARK: - Hide keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
// MARK: - Error message
extension UIViewController {
    public func present(errorMessage: ErrorMessage) {
      let errorAlertController = UIAlertController(title: errorMessage.title,
                                                   message: errorMessage.message,
                                                   preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default)
      errorAlertController.addAction(okAction)
      present(errorAlertController, animated: true, completion: nil)
    }
}
