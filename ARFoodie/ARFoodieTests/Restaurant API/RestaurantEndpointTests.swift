//
//  RestaurantEndpointTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/8/22.
//

import XCTest
import ARFoodie

class RestaurantEndpointTests: XCTestCase {
    func test_restaurant_endPointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        let coordinate = Coordinate(longitude: 100, latitude: 23)

        let received = RestaurantEndpoint.get(from: coordinate).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, baseURL.scheme, "scheme")
        XCTAssertEqual(received.host, baseURL.host, "host")
        XCTAssertEqual(received.path, "/nearbysearch/json")
        XCTAssertEqual(received.query?.contains("location=\(coordinate.latitude),\(coordinate.longitude)"), true, "location query param")
        XCTAssertEqual(received.query?.contains("rankby=distance"), true, "rankby query param")
        XCTAssertEqual(received.query?.contains("type=restaurant"), true, "type query param")
        XCTAssertEqual(received.query?.contains("language=zh_TW"), true, "language query param")
    }
}
