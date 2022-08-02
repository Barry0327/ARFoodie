//
//  RemoteRestaurantLoaderTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/7/30.
//

import XCTest
import ARFoodie

class RemoteRestaurantLoaderTests: XCTestCase {
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load() { _ in }
        sut.load() { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWithResult: .failure(.connectionError), when: {
            client.completeWithResult(.failure(anyError()))
        })
    }

    func test_load_deliversErrorOnNone2XXHTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 300, 301, 410, 500]

        samples.enumerated().forEach { (index, statusCode) in
            let response = response(statusCode: statusCode)

            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                client.completeWithResult(.success((Data(), response)), at: index)
            })
        }
    }

    func test_load_deliversErrorOn2XXHTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        valid2XXStatusCodes().enumerated().forEach { (index, statusCode) in
            expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
                let response = response(statusCode: statusCode)
                let data = "invalidJSON".data(using: .utf8)!
                client.completeWithResult(.success((data, response)), at: index)
            })
        }
    }

    func test_load_deliversNoItemsOn2XXHTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        let samples = [200, 201, 250, 299]

        samples.enumerated().forEach { (index, statusCode) in
            expect(sut, toCompleteWithResult: .success([]), when: {
                let response = response(statusCode: 200)
                let data = makeItemsJSON([])
                client.completeWithResult(.success((data, response)), at: index)
            })
        }
    }

    func test_load_deliversItemsOn2XXHTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let item1 = makeRestaurant(name: "first", latitude: 22, longitude: 33, rating: 4.5, userRatingsTotal: 123)
        let item2 = makeRestaurant(name: "second", latitude: 11, longitude: 123)

        let samples = [200, 201, 250, 299]

        samples.enumerated().forEach { (index, statusCode) in
            expect(sut, toCompleteWithResult: .success([item1.model, item2.model]), when: {
                let response = response(statusCode: 200)
                let data = makeItemsJSON([item1.json, item2.json])
                client.completeWithResult(.success((data, response)), at: index)
            })
        }
    }

    func test_load_doesNotDeliversResultIfSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteRestaurantLoader? = RemoteRestaurantLoader(url: url, client: client)

        var capturedResult: [RestaurantLoader.Result] = []

        sut?.load(completion: { result in
            capturedResult.append(result)
        })

        sut = nil
        client.completeWithResult(.failure(anyError()))

        XCTAssertTrue(capturedResult.isEmpty)
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

    private func expect(
        _ sut: RemoteRestaurantLoader,
        toCompleteWithResult expectedResult: RemoteRestaurantLoader.Result,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        sut.load() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteRestaurantLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
        }

        action()
    }

    private func makeRestaurant(
        name: String,
        latitude: Double,
        longitude: Double,
        rating: Double? = nil,
        userRatingsTotal: Double? = nil
    ) -> (model: Restaurant, json: [String: Any]) {
        let restaurant = Restaurant.init(id: UUID().uuidString, name: name, latitude: latitude, longitude: longitude, rating: rating, userRatingsTotal: userRatingsTotal)

        let json: [String: Any] = [
            "name": restaurant.name,
            "place_id": restaurant.id,
            "geometry": [
                "location": [
                    "lat": restaurant.latitude,
                    "lng": restaurant.longitude
                ]
            ],
            "rating": restaurant.rating,
            "user_ratings_total": restaurant.userRatingsTotal
        ].compactMapValues { $0 }
        return (restaurant, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = [
            "results": items
        ]
        let data = try! JSONSerialization.data(withJSONObject: json)
        return data
    }

    class HTTPClientSpy: HTTPClient {
        private var messages: [(url: URL, completion: (HTTPClient.Result) -> Void)] = []

        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }

        func completeWithResult(_ result: HTTPClient.Result, at index: Int = 0) {
            messages[index].completion(result)
        }
    }

    private func anyError() -> NSError {
        .init(domain: "Test", code: 0)
    }

    private func anyURL() -> URL {
        URL(string: "https://any.com")!
    }

    private func valid2XXStatusCodes() -> [Int] {
        [200, 201, 250, 299]
    }

    private func response(statusCode: Int) -> HTTPURLResponse {
        .init(
            url: anyURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
