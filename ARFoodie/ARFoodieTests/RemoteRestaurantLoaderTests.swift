//
//  RemoteRestaurantLoaderTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import XCTest
import ARFoodie

class RemoteRestaurantLoaderTests: XCTestCase {

    func test_init_dosetNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertEqual(client.requestCallCount, 0)
    }

    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load()
        sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://any.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteRestaurantLoader, clientSpy: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRestaurantLoader(url: url, client: client)

        trackMemoryLeak(sut, file: file, line: line)
        trackMemoryLeak(client, file: file, line: line)

        return (sut, client)
    }

    class HTTPClientSpy: HTTPClient {
        private(set) var requestedURLs: [URL] = []

        var requestCallCount: Int {
            requestedURLs.count
        }

        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
        }
    }

    private func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
