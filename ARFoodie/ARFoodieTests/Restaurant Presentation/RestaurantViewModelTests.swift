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

    func test_loadTwice_requestTwiceIfPreviousRequestCompleteSuccessfully() {
        let (sut, loader) = makeSUT()

        sut.load()
        loader.completeLoading()
        sut.load()

        XCTAssertEqual(loader.loadCallCount, 2, "Expected another load request once first request complete successfully")
    }

    func test_loadTwice_requestTwiceIfPreviousRequestCompleteWithError() {
        let (sut, loader) = makeSUT()

        sut.load()
        loader.completeLoadingWithError()
        sut.load()

        XCTAssertEqual(loader.loadCallCount, 2, "Expected another load request once first request complete with error")
    }

    func test_loadAction_alterLoadingState() {
        let (sut, loader) = makeSUT()
        XCTAssertFalse(sut.isLoading)

        sut.load()
        XCTAssertTrue(sut.isLoading)

        loader.completeLoading(at: 0)
        XCTAssertFalse(sut.isLoading)

        sut.load()
        XCTAssertTrue(sut.isLoading)

        loader.completeLoadingWithError(at: 1)
        XCTAssertFalse(sut.isLoading)
    }

    func test_load_setRestaurantsOnceCompleteSuccessfully() {
        let (sut, loader) = makeSUT()
        let restaurants = [
            makeUniqueRestaurant(name: "Test1", latitude: 10, longitude: 20),
            makeUniqueRestaurant(name: "Test2", latitude: 20, longitude: 30)
        ]
        XCTAssertEqual(sut.restaurants, [])

        sut.load()
        loader.completeLoading(with: restaurants, at: 0)
        XCTAssertEqual(sut.restaurants, restaurants)
    }

    func test_load_setErrorOnceCompleteWithError() {
        let (sut, loader) = makeSUT()
        let error = anyError()
        XCTAssertNil(sut.error)

        sut.load()
        loader.completeLoadingWithError()

        guard let receivedError = sut.error as? NSError else {
            return XCTFail("Expected \(error) instance, got \(String(describing: sut.error)) instead")
        }
        XCTAssertEqual(receivedError, error)
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

        func completeLoading(with restaurants: [Restaurant] = [], at index: Int = 0) {
            requests[index].send(restaurants)
            requests[index].send(completion: .finished)
        }

        func completeLoadingWithError(at index: Int = 0) {
            requests[index].send(completion: .failure(anyError()))
        }
    }

    private func makeUniqueRestaurant(
        name: String,
        latitude: Double,
        longitude: Double,
        rating: Double? = nil,
        userRatingsTotal: Double? = nil
    ) -> Restaurant {
        let restaurant = Restaurant.init(
            id: UUID().uuidString,
            name: name,
            coordinate: .init(longitude: longitude, latitude: latitude),
            rating: rating,
            userRatingsTotal: userRatingsTotal
        )
        return restaurant
    }
}
