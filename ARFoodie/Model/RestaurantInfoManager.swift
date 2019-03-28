//
//  RestaurantInfo.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/28.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Alamofire

class RestaurantInfoManager {

    static let shared: RestaurantInfoManager = RestaurantInfoManager()

    weak var delegate: RestaurantInfoDelegate?

    func fetchRestaurant() {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

        let parameters: Parameters = [

            "location": "25.0634243,121.5194408",
            "radius": "500",
            "types": "food",
            "language": "zh_TW",
            "key": "AIzaSyCnDQviBdsqd55DfGHkSToCnXXz66WEIhY"

        ]

        AF.request(endPointURL, method: HTTPMethod.get, parameters: parameters).responseJSON { (response) in

            if response.error != nil {
                return
            }


            if response.result.isSuccess {

                guard let json = response.result.value as? [String: Any] else {
                    print("Failed paring 1")
                    return
                }

                guard let status = json["status"] as? String else {
                    print("Failed paring 2")
                    return
                }

                guard status == "OK" else {
                    print("Request Failed")
                    return
                }

                guard var restaurantList = json["results"] as? [[String: Any]] else {
                    print("Failed paring 3")
                    return
                }

                // first and last item are always not restaurant
                restaurantList.removeFirst()
                restaurantList.removeLast()

                var restaurants: [Restaurant] = []

                for item in restaurantList {

                    guard let geometry = item["geometry"] as? [String: Any] else {
                        print("Failed paring 4")
                        return
                    }

                    guard let locaiton = geometry["location"] as? [String: Double] else {
                        print("Failed paring 5")
                        return
                    }

                    guard
                        let lat = locaiton["lat"],
                        let lng = locaiton["lng"]
                        else {
                            print("Failed paring 6")
                            return
                    }

                    guard let name = item["name"] as? String else {
                        print("Failed paring 7")
                        return
                    }

                    let restaurant = Restaurant.init(name: name, photo: nil, lat: lat, lng: lng)

                    restaurants.append(restaurant)

                }
                print(restaurants)

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.manager(RestaurantInfoManager.shared, didFetch: restaurants)

                }

            }
        }

    }
}
