//
//  RestaurantSnapshotTests.swift
//  RestaurantSnapshotTests
//
//  Created by Chen Yi-Wei on 2022/8/9.
//

import XCTest
import ARFoodieiOS

class RestaurantSnapshotTests: XCTestCase {
    func test_initContent() {
        let sut = ARRestaurantViewController()
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "RESTAURANT_INITIAL_CONTENT_light")
    }
}
