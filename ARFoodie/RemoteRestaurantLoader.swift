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
        case invalidData
    }

    private var validStatusCodes: [Int] = .init(200...299)

    public func load(completion: @escaping (Result) -> Void) {
        client.get(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                guard self.validStatusCodes.contains(response.statusCode) else {
                    completion(.failure(.invalidData))
                    return
                }
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    completion(.success([]))
                }
                else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectionError))
            }
        }
    }
}
