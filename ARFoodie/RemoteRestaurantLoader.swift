//
//  RemoteRestaurantLoader.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/7/31.
//

import Foundation

public class RemoteRestaurantLoader {
    public typealias Result = Swift.Result<[Restaurant], Error>

    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectionError
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { result in
            completion(.failure(.connectionError))
        }
    }
}
