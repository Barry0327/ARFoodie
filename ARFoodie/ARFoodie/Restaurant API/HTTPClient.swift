//
//  HTTPClient.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/31.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(HTTPURLResponse, Data), Error>

    func get(url: URL, completion: @escaping (Result) -> Void)
}
