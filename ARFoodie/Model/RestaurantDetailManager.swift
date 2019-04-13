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

class RestaurantDetailManager {

    static let shared: RestaurantDetailManager = RestaurantDetailManager()

    weak var delegate: RestaurantDetailDelegate?

    // swiftlint:disable cyclomatic_complexity

    func fetchDetails(placeID: String) {

        let endPointURL = "https://maps.googleapis.com/maps/api/place/details/json"

        let parameters: Parameters = [
            "placeid": placeID,
            "key": "AIzaSyCnDQviBdsqd55DfGHkSToCnXXz66WEIhY",
            "language": "zh_TW"
        ]

        Alamofire.request(endPointURL, method: .get, parameters: parameters).responseJSON { (response) in

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

                var weeKDayForToday: String = "暫無資料"

                if
                    let openingHours = result["opening_hours"] as? [String: Any],
                    let weekDays = openingHours["weekday_text"] as? [String]
                {
                    let today = Date()
                    let calendar = Calendar.current
                    let weekDay = calendar.component(.weekday, from: today)

                    switch weekDay {
                    case 1:
                        weeKDayForToday = weekDays[6]
                    case 2:
                        weeKDayForToday = weekDays[0]
                    case 3:
                        weeKDayForToday = weekDays[1]
                    case 4:
                        weeKDayForToday = weekDays[2]
                    case 5:
                        weeKDayForToday = weekDays[3]
                    case 6:
                        weeKDayForToday = weekDays[4]
                    case 7:
                        weeKDayForToday = weekDays[5]
                    default:
                        weeKDayForToday = "暫無資料"
                    }
                }

                let restaurant = RestaurantDetail.init(name: name, address: address, phoneNumber: phoneNumber, photoRef: photoRef, coordinate: coordinate, businessHours: weeKDayForToday)

                print(restaurant.photoRef)

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
