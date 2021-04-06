//
//  RestaurantDetailManager.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/4/2.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

struct PlaceParameters: Codable {
    let placeid: String
    let key: String
    let language: String
}

class RestaurantDetailManager {

    weak var delegate: RestaurantDetailDelegate?

    let apiKey: String = {
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            return key
        }
        return ""
    }()

    // swiftlint:disable cyclomatic_complexity

    func fetchDetails(placeID: String) {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/details/json"

        let parameters = PlaceParameters(placeid: placeID, key: apiKey, language: "zh_TW")

        AF.request(endPointURL, method: .get, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON { (response) in

            if response.error != nil {

                print("Failed to fetch restaurant detail")
                self.delegate?.manager(self, didFailed: response.error!)
                return
            }

            switch response.result {
            case .success(let data):
                guard let json = data as? [String: Any] else {
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
                    let name = result["name"] as? String,
                    let geometry = result["geometry"] as? [String: Any]
                else {
                    print("Failed parsing 3")
                    return
                }
                var photoRef = "暫無資料"
                var phoneNumber = "暫無資料"

                if let photos = result["photos"] as? [[String: Any]] {

                    let photo = photos[0]

                    if let photoRefString = photo["photo_reference"] as? String {
                        photoRef = photoRefString
                    }
                }

                if let formattedPhoneNumber = result["formatted_phone_number"] as? String {
                    phoneNumber = formattedPhoneNumber

                }

                guard
                    let location = geometry["location"] as? [String: Double]
                else {
                    print("Failed parsing 4")
                    return
                }

                guard
                    let lat = location["lat"],
                    let lng = location["lng"]
                else {
                    print("Failed parsing 5")
                    return
                }

                let coordinate = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)

                var isOpening: Bool?

                if
                    let openingHours = result["opening_hours"] as? [String: Any],
                    let openNow = openingHours["open_now"] as? Bool
                {
                    isOpening = openNow
                }

                var rating: Double?
                var userRatingTotal: Double?

                if
                    let ratingStar = result["rating"] as? Double,
                    let userRatingTotalNumber = result["user_ratings_total"] as? Double
                {
                    rating = ratingStar
                    userRatingTotal = userRatingTotalNumber
                }

                let restaurant = RestaurantDetail.init(name: name, address: address, phoneNumber: phoneNumber, photo: nil, coordinate: coordinate, isOpening: isOpening, rating: rating, userRatingsTotal: userRatingTotal)

                DispatchQueue.main.async { [weak self] in

                    guard let self = self else { return }

                    self.delegate?.manager(self, didFetch: restaurant)

                }
            case .failure(let error):
                print(error.errorDescription ?? "")
                self.delegate?.manager(self, didFailed: response.error!)
            }
        }
    }
}
