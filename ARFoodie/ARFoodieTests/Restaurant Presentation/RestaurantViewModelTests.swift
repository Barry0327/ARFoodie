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
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    func test_load_requestRestaurantsFromLoader() {
        let (sut, loader) = makeSUT()

        sut.load()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a load request once call")
    }

    func test_loadTwice_doseNotRequestTwiceIfPreviousRequestNotCompleteYet() {

        let (sut, loader) = makeSUT()

        sut.load()
        sut.load()

        XCTAssertEqual(loader.loadCallCount, 1, "Expected only a load request before first request complete")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RestaurantViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = RestaurantViewModel(loader: loader.loadPublisher)

        trackMemoryLeak(loader, file: file, line: line)
        trackMemoryLeak(sut, file: file, line: line)
        return (sut, loader)
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
