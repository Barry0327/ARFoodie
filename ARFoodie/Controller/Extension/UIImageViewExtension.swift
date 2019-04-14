//
//  UIImageViewExtension.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/14.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {

    func fetchImage(with ref: String) {

        print(ref)

        guard ref != "暫無資料" else {

            print("Return")
            return

        }

        let endPointURL = "https://maps.googleapis.com/maps/api/place/photo"

        let parameters: Parameters = [

            "photoreference": ref,
            "key": "AIzaSyCnDQviBdsqd55DfGHkSToCnXXz66WEIhY",
            "maxheight": 250
        ]

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
