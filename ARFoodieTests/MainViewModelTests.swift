//
//  MainViewModelTests.swift
//  ARFoodieTests
//
//  Created by Barry Chen on 2021/4/12.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay
import RxBlocking
import CoreLocation
@testable import ARFoodie

enum TestError: Error {
    case serviceError
    case fileNotFound
    case decodeFailed
}
extension TestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serviceError: return "連線失敗"
        case .fileNotFound: return "無法找到檔案"
        case .decodeFailed: return "解析資料失敗"
        }
    }
}

class TestPlaceService: PlacesService {

    var restaurants: PublishSubject<[Restaurant]> = .init()
    static var lastMethodCall: String?

    func nearbyRestaurants(coordinate: Coordinate) -> Single<[Restaurant]> {
        TestPlaceService.lastMethodCall = #function
        return restaurants.asSingle()
    }

    func restaurantDetail(placeID: String) -> Single<RestaurantDetail> {
        TestPlaceService.lastMethodCall = #function
        return Single<RestaurantDetail>.create { (single) -> Disposable in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                guard let data = cachedFileData(name: "place_detail") else {
                    single(.failure(TestError.fileNotFound))
                    return
                }

                let decoder = JSONDecoder()
                decoder.userInfo[.contentIdentifier] = "result"

                let envelope = try? decoder.decode(GooglePlacesEnvelope<RestaurantDetail>.self, from: data)
                guard let detail = envelope?.content else {
                    single(.failure(TestError.decodeFailed))
                    return
                }
                single(.success(detail))
            }
            return Disposables.create()
        }
    }
}

class TestLocaitonManager: LocationService {
    let coordinate: PublishRelay<Coordinate> = .init()

    let locationError: PublishRelay<Error> = .init()

    var currentLocation: CLLocation?

    func getCurrentLocation() {
        let coordinate: Coordinate = ("25.0", "125.0")
        self.coordinate.accept(coordinate)
        let location = CLLocation(latitude: 25.0, longitude: 125.0)
        currentLocation = location
    }

}

class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!
    var testLocationManager: TestLocaitonManager!
    var testPlaceService: TestPlaceService!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testLocationManager = TestLocaitonManager()
        testPlaceService = TestPlaceService()
        viewModel = MainViewModel(placesService: testPlaceService, locationService: testLocationManager)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_search_restaurants() throws {
        guard let data = cachedFileData(name: "nearby_places") else {
            XCTFail("File not found")
            return
        }

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "results"
        let envelope = try decoder.decode(GooglePlacesEnvelope<[Restaurant]>.self, from: data)

        viewModel.searchRestaurants()

        testPlaceService.restaurants.onNext(envelope.content)
        testPlaceService.restaurants.onCompleted()

        let restaurantsObservable = viewModel.restaurants.asObservable().subscribe(on: scheduler)
        let restaurants = try restaurantsObservable.toBlocking(timeout: 1.0).first()

        XCTAssertEqual(viewModel.currentLocation, testLocationManager.currentLocation)
        XCTAssertEqual(restaurants?.count, 20)
        XCTAssertEqual(restaurants?.first?.name, "御膳煲養生雞湯館")
        XCTAssertEqual(restaurants?.first?.placeID, "ChIJLxlLh-qrQjQRlC40U-np8EQ")

        XCTAssertEqual(TestPlaceService.lastMethodCall, "nearbyRestaurants(coordinate:)")
    }

    func test_search_restaurants_failed() throws {
        viewModel.searchRestaurants()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.testPlaceService.restaurants.onError(TestError.serviceError)
        }

        let errorMessageObservable = viewModel.errorMessage.asObservable().subscribe(on: scheduler)
        let errorMessage = try errorMessageObservable.toBlocking(timeout: 2).first()

        XCTAssertEqual(errorMessage?.title, "連線錯誤")
        XCTAssertEqual(errorMessage?.message, "連線失敗")

        XCTAssertEqual(TestPlaceService.lastMethodCall, "nearbyRestaurants(coordinate:)")
    }

    func test_get_location_failed() throws {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.testLocationManager.locationError.accept(TestError.serviceError)
        }

        let errorMessageObservable = viewModel.errorMessage.asObservable().subscribe(on: scheduler)
        let errorMessage = try errorMessageObservable.toBlocking(timeout: 2).first()

        XCTAssertEqual(errorMessage?.title, "定位失敗")
    }

}
