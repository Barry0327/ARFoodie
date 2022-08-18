//
//  RestaurantViewModelTests.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/8/18.
//

import XCTest
import Combine
import ARFoodie

class RestaurantViewModelTests: XCTestCase {
    func test_init_doseNotRequestRestaurants() {
        let loader = LoaderSpy()
        let _ = RestaurantViewModel(loader: loader.loadPublisher)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    private class LoaderSpy {
        private var requests: [PassthroughSubject<[Restaurant], Error>] = []

        var loadCallCount: Int {
            requests.count
        }

        func loadPublisher() -> AnyPublisher<[Restaurant], Error> {
            let publisher = PassthroughSubject<[Restaurant], Error>.init()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
    }
}
