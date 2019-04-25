//
//  UIImageViewExtension.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

extension UIImageView {

    func fetchImage(with ref: String) {

        let apiKey: String = {

            if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
                return key
            }
            return ""
        }()

        guard ref != "暫無資料" else {

            print("Return")
            return

        }

        let endPointURL = "https://maps.googleapis.com/maps/api/place/photo"

        let parameters: Parameters = [

            "photoreference": ref,
            "key": apiKey,
            "maxheight": 100,
            "maxwidth": 80
        ]

        let imageCache = NSCache<NSString, UIImage>()

        if let imageFromCache = imageCache.object(forKey: ref as NSString) {
            self.image = imageFromCache
            print("LoadImageFromCache")
            return
        }

        Alamofire.request(endPointURL, method: .get, parameters: parameters).responseData { (response) in

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

                        let image = UIImage(data: data)

                        imageCache.setObject(image!, forKey: ref as NSString)

                        self.image = image

                        print(response.result.debugDescription)
                    }
                } else {
                    print("Failed to get image data")
                }
            }

        }
    }
}
