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

    private struct UnexpectedValuesRepresentation: Error {}

    func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = URLRequest.init(url: url)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        .resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    override func setUp() {
        super.setUp()

        URLProtocolStub.startInterceptingRequests()

    }

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performGetRequestFromURL() {
        let url = anyURL()

        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observerRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(url: url) { _ in }
        wait(for: [exp], timeout: 1.0)
    }

    func test_getFromURL_failsOnRequestError() {
        let error = anyError()

        let receivedError = resultErrorFor(data: nil, response: nil, error: error) as? NSError

        XCTAssertEqual(receivedError?.domain, error.domain)
        XCTAssertEqual(receivedError?.code, error.code)
    }

    func test_getFromURL_failsOnAllNilValues() {
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackMemoryLeak(sut, file: file, line: line)
        return sut
    }

    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let sut = makeSUT(file: file, line: line)

        URLProtocolStub.stub(data: data, response: response, error: error)

        var receivedError: Error?

        let exp = expectation(description: "Wait for completion")

        sut.get(url: anyURL()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
                break
            default:
                XCTFail("Expected failure , got \(result) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedError
    }

    class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static func stub(data: Data?, response: URLResponse?, error: Error?) {
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
