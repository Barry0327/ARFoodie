//
//  Portocol.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/28.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

protocol RestaurantInfoDelegate: AnyObject {

    func restaurantInfoManager(didFetch restaurants: [Restaurant])

    func restaurantInfoManager(didFailed with: Error)

}

protocol RestaurantDetailDelegate: AnyObject {

    func restaurantDetailManager(didFetch restaurant: RestaurantDetail)

    func restaurantDetailManager(didFailed with: Error)

}

protocol LiveStreamManagerDelegate: AnyObject {

    func manager(_ manager: LiveStreamManager, didFetch broadcastURL: String)
}
