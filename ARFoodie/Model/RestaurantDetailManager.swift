//
//  RestaurantDetailManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/2.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Alamofire

class RestaurantDetailManager {

    static let shared: RestaurantDetailManager = RestaurantDetailManager()

    weak var delegate: RestaurantDetailDelegate?

    func fetchDetails(placeID: String) {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/details/json"

        let parameters: Parameters = [
            "placeid": placeID,
            "key": "AIzaSyCnDQviBdsqd55DfGHkSToCnXXz66WEIhY",
            "language": "zh_TW"
        ]

        AF.request(endPointURL, method: .get, parameters: parameters).responseJSON { (response) in

            if response.error != nil {

                return
            }

            if response.result.isSuccess {

                guard let json = response.result.value as? [String: Any] else {
                    print("Failed parsing 1")
                    return
                }
                guard
                    let result = json["result"] as? [String: Any],
                    let status = json["status"] as? String
                else {
                    print("Failed parsiing 2")
                    return
                }
                guard
                    status == "OK",
                    let address = result["formatted_address"] as? String,
                    let phoneNumber = result["formatted_phone_number"] as? String,
                    let name = result["name"] as? String,
                    let photos = result["photos"] as? [[String: Any]]
                    else {
                        print("Failed parsing 3")
                        return
                }
                let photo = photos[0]
                guard let photoRef = photo["photo_reference"] as? String else {
                    print("Failed parsing 4")
                    return
                }

//                if let openingHours = result["opening_hours"] as? [String: Any] {
//                    print(openingHours)
//                }

                let restaurant = RestaurantDetail.init(name: name, address: address, phoneNumber: phoneNumber, photoRef: photoRef)

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.delegate?.manager(RestaurantDetailManager.shared, didFetch: restaurant)

                }
            }
        }
    }
}
