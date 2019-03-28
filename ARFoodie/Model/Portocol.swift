//
//  Portocol.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2019/3/28.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

protocol RestaurantInfoDelegate: AnyObject {

    func manager(_ manager: RestaurantInfoManager, didFetch restaurants: [Restaurant])

    func manager(_ manager: RestaurantInfoManager, didFailed with: Error)

}
