//
//  ARRestaurantUIIntegrationTests.swift
//  ARFoodieAppTests
//
//  Created by Chen Yi-Wei on 2022/9/7.
//  Copyright © 2022 Chen Yi-Wei. All rights reserved.
//

import XCTest
import Combine
import ARFoodie
import ARFoodieiOS
import ARFoodieApp

class ARRestaurantUIIntegrationTests: XCTestCase {
    func test_tapSearchButton_requestRestaurantsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no load request before tap search button")

        sut.simulateTapSearchButton()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a load request once tap search button")

        sut.simulateTapSearchButton()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected no more load request before previous request complete")

        loader.completeLoad()
        sut.simulateTapSearchButton()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another load request when tap search button and previous request has completed")
    }

    private func makeSUT() -> (sut: ARRestaurantViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = ARRestaurantUIComposer.arRestaurantUIComposedWith(loader: loader.makeLoadPublisher)

        return (sut, loader)
    }

    class LoaderSpy {
        private var requests: [PassthroughSubject<[Restaurant], Error>] = []

        var loadCallCount: Int {
            requests.count
        }

        func makeLoadPublisher() -> AnyPublisher<[Restaurant], Error> {
            let publisher = PassthroughSubject<[Restaurant], Error>.init()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeLoad(with restaurants: [Restaurant] = [], at index: Int = 0) {
            requests[index].send(restaurants)
            requests[index].send(completion: .finished)
        }
    }
}

extension ARRestaurantViewController {
    func simulateTapSearchButton() {
        searchButton.sendActions(for: .touchUpInside)
    }
}
