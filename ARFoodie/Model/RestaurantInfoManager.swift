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

    weak var delegate: RestaurantInfoDelegate?

    let apiKey: String = {

        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            return key
        }
        return ""
    }()

    // swiftlint:disable cyclomatic_complexity

    func fetchRestaurant(lat: String, lng: String) {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

        let parameters: Parameters = [

            "location": "\(lat),\(lng)",
            "rankby": "distance",
            "types": "restaurant",
            "language": "zh_TW",
            "key": apiKey

        ]
        Alamofire.request(endPointURL, method: HTTPMethod.get, parameters: parameters).responseJSON { (response) in

            if response.error != nil {

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.manager(self, didFailed: response.error!)

                }
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

                guard
                    status == "OK",
                    var restaurantList = json["results"] as? [[String: Any]]
                else {
                    print("Failed paring 3")
                    return
                }

                restaurantList.removeLast(6)

                var restaurants: [Restaurant] = []

                for item in restaurantList {

                    guard
                        let geometry = item["geometry"] as? [String: Any],
                        let name = item["name"] as? String,
                        let rating = item["rating"] as? Double?,
                        let userRatingsTotal = item["user_ratings_total"] as? Double?,
                        let placeID = item["place_id"] as? String
                    else {
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

                    let restaurant = Restaurant.init(placeID: placeID, name: name, lat: lat, lng: lng, rating: rating, userRatingsTotal: userRatingsTotal)

                    restaurants.append(restaurant)

                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.manager(self, didFetch: restaurants)

                }
            }
        }
    }

    func fetchViaDecoder(lat: String, lng: String) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "maps/api/place/nearbysearch/json"
        let parameters = [

            "location": "\(lat),\(lng)",
            "rankby": "distance",
            "types": "restaurant",
            "language": "zh_TW",
            "key": apiKey

        ]
        urlComponents.queryItems = convertDicToQuertItems(parameters: parameters)

        let url = urlComponents.url!

        let task = URLSession.shared.dataTask(with: url) { (data, resonese, error) in

        }
        task.resume()
    }

    func convertDicToQuertItems(parameters: [String: String]) -> [URLQueryItem] {

        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {

            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }

        return queryItems
    }
}
