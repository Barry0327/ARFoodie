//
//  URLSessionHTTPClientTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/8/4.
//

import XCTest
import ARFoodie

class URLSessionHTTPClient: HTTPClient {
    let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = URLRequest.init(url: url)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        let sut = URLSessionHTTPClient()
        let url = anyURL()
        let error = anyError()

        URLProtocolStub.stub(url: url, data: nil, response: nil, error: error)

        let exp = expectation(description: "Wait for completion")

        sut.get(url: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }

    class URLProtocolStub: URLProtocol {
        private static var stubs: [URL: Stub] = [:]

        private struct Stub {
            let data: Data?
            let response: HTTPURLResponse?
            let error: Error?
        }

        static func stub(url: URL, data: Data?, response: HTTPURLResponse?, error: Error?) {
            let stub = Stub.init(data: data, response: response, error: error)
            stubs[url] = stub
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs.removeAll()
        }

        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false }

            return stubs[url] != nil

        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }

            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
