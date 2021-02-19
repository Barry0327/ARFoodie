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

struct PlaceImageParameters: Codable {
    let photoreference: String
    let key: String
    let maxheight: Int
    let maxwidth: Int
}

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


        let parameters = PlaceImageParameters(photoreference: ref, key: apiKey, maxheight: 100, maxwidth: 80)

        let imageCache = NSCache<NSString, UIImage>()

        if let imageFromCache = imageCache.object(forKey: ref as NSString) {
            self.image = imageFromCache
            print("LoadImageFromCache")
            return
        }

        AF.request(endPointURL, parameters: parameters, encoder: JSONParameterEncoder.default).responseData { [weak self] (response) in
            switch response.result {
            case .success(let data):
                guard let self = self else { return }

                let image = UIImage(data: data)

                imageCache.setObject(image!, forKey: ref as NSString)

                self.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
