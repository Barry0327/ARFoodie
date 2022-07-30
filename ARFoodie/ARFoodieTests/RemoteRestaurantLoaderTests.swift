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
    let url: URL
    let client: HTTPClient

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(url: url, completion: { _ in })
    }
}

class RemoteRestaurantLoaderTests: XCTestCase {

    func test_init_dosetNotRequestDataFromURL() {
        let anyURL = URL(string: "https://any.com")!
        let client = HTTPClientSpy()
        let _ = RemoteRestaurantLoader(url: anyURL, client: client)

        XCTAssertEqual(client.requestCallCount, 0)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteRestaurantLoader(url: url, client: client)

        sut.load()

        XCTAssertEqual(client.receivedURLs, [url])
    }

    class HTTPClientSpy: HTTPClient {
        private(set) var receivedURLs: [URL] = []

        var requestCallCount: Int {
            receivedURLs.count
        }

        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            receivedURLs.append(url)
        }
    }
}
