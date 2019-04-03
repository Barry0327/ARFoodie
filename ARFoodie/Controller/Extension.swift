//
//  Extension.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/1.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import ARKit
import Alamofire

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension SCNNode {

    // This solved flickering issue.
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
}

extension UIColor {

    // swiftlint:disable all
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)

    }
    // swiftlint:enable all
}

extension CALayer {

    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xPosition: CGFloat = 0,
        yPosition: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPosition, height: yPosition)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxValue = -spread
            let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIImageView {

    func fetchImage(with ref: String) {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/photo"

        let parameters: Parameters = [

            "photoreference": ref,
            "key": "AIzaSyCnDQviBdsqd55DfGHkSToCnXXz66WEIhY",
            "maxheight": 250
        ]

        AF.request(endPointURL, method: .get, parameters: parameters).responseData { (response) in

            if response.error != nil {
                print("Image request failed")
                return
        }
            if response.result.isSuccess {

                if let data = response.result.value {

                    DispatchQueue.main.async { [weak self] in

                        guard let self = self else {
                            return
                        }
                        self.image = UIImage(data: data)
                        print(response.result.debugDescription)
                    }
                } else {
                    print("Failed to get image data")
                }
            }

        }
    }
}
