//
//  RestaurantLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import Foundation

public protocol RestaurantLoader {
    typealias Result = Swift.Result<[Restaurant], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
