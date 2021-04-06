//
//  PlacesService.swift
//  ARFoodie
//
//  Created by Barry Chen on 2021/4/1.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import Foundation
import RxSwift

protocol PlacesService {
    func nearbyRestaurants(coordinate: Coordinate) -> Single<[Restaurant]>
    func restaurantDetail(placeID: String) -> Single<RestaurantDetail>
}
