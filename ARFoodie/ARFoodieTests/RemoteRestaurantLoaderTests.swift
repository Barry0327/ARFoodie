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
        let error = anyError()

        var capturedResult: [RemoteRestaurantLoader.Result] = []
        sut.load() { result in capturedResult.append(result) }
        client.completeWithResult(.failure(error))

        XCTAssertEqual(capturedResult, [.failure(.connectionError)])
    }

    func test_load_deliversErrorOnNone2XXHTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 300, 301, 410, 500]

        samples.enumerated().forEach { (index, statusCode) in
            let response = HTTPURLResponse(
                url: anyURL(),
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            var capturedResult: [RemoteRestaurantLoader.Result] = []
            sut.load() { result in capturedResult.append(result) }
            client.completeWithResult(.success((Data(), response)), at: index)

            XCTAssertEqual(capturedResult, [.failure(.invalidData)])
        }
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

    private func trackMemoryLeak(_ instance: AnyObject, file: StaticString, line: UInt) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
