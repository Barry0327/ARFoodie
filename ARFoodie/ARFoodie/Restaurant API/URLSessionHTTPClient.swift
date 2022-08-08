//
//  URLSessionHTTPClient.swift
//  ARFoodie
//
//  Created by Chen Yi-Wei on 2022/8/7.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let request = URLRequest.init(url: url)
        session.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
            else if let error = error {
                completion(.failure(error))
            }
            else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        .resume()
    }
}
