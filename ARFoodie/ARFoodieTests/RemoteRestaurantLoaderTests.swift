//
//  RemoteRestaurantLoaderTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import XCTest


protocol HTTPClient {
    typealias Result = Swift.Result<(HTTPURLResponse, Data), Error>

    func get(url: URL, completion: @escaping (Result) -> Void)
}

class RemoteRestaurantLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }
}

class RemoteRestaurantLoaderTests: XCTestCase {

    func test_init_dosetNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let _ = RemoteRestaurantLoader(client: client)

        XCTAssertEqual(client.requestCallCount, 0)
    }

    class HTTPClientSpy: HTTPClient {
        private var receivedURLs: [URL] = []

        var requestCallCount: Int {
            receivedURLs.count
        }

        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {

        }
    }
}
