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
    func test_getFromURL_performGetRequestFromURL() {
        URLProtocolStub.startInterceptingRequests()
        let sut = URLSessionHTTPClient()
        let url = anyURL()

        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observerRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        sut.get(url: url) { _ in }
        wait(for: [exp], timeout: 1.0)

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        let sut = URLSessionHTTPClient()
        let url = anyURL()
        let error = anyError()

        URLProtocolStub.stub(data: nil, response: nil, error: error)

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
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: HTTPURLResponse?
            let error: Error?
        }

        static func stub(data: Data?, response: HTTPURLResponse?, error: Error?) {
            stub = Stub.init(data: data, response: response, error: error)
        }

        static func observerRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }

        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
