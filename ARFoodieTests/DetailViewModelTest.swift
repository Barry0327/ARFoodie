//
//  DetailViewModelTest.swift
//  ARFoodieTests
//
//  Created by Barry Chen on 2021/4/12.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import ARFoodie

class DetailViewModelTest: XCTestCase {

    var viewModel: DetailViewModel!
    var testPlaceService: TestPlaceService!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testPlaceService = TestPlaceService()
        scheduler = ConcurrentDispatchQueueScheduler.init(qos: .default)
        viewModel = DetailViewModel(placeID: "", placesService: testPlaceService)
    }

    func test_fetch_restaurantDetail() throws {
        viewModel.fetchRestaurtantDetail()

        guard let data = cachedFileData(name: "place_detail") else {
            XCTFail("File not found")
            return
        }

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "result"

        let envelope = try decoder.decode(GooglePlacesEnvelope<RestaurantDetail>.self, from: data)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.testPlaceService.restaurnatDetail.onNext(envelope.content)
            self.testPlaceService.restaurnatDetail.onCompleted()
        }

        let detailObservable = viewModel.restaurantDetail.asObservable().subscribe(on: scheduler).skip(1)
        let result = try detailObservable.toBlocking(timeout: 2.0).first()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "皇星魚翅餐廳")
        XCTAssertEqual(result?.address, "105台灣台北市松山區光復北路32號2樓")
        XCTAssertEqual(result?.reviews.count, 5)

        XCTAssertEqual(result?.name, viewModel.navigationTitle.value)
    }

    func test_fetch_restaurantDetail_failed() throws {
        viewModel.fetchRestaurtantDetail()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.testPlaceService.restaurnatDetail.onError(TestError.serviceError)
        }

        let errorMessageObservable = viewModel.errorMessage.asObservable().subscribe(on: scheduler)
        let result = try errorMessageObservable.toBlocking(timeout: 1.0).first()
        XCTAssertEqual(result?.title, "連線失敗")
    }

    func test_select_phone_number() throws {
        let detail: RestaurantDetail = RestaurantDetail(name: "", address: "", phoneNumber: "02 2242 8888", photo: nil, coordinate: .init(latitude: 25, longitude: 125), isOpening: nil, rating: nil, userRatingsTotal: nil, reviews: [])
        viewModel.restaurantDetail.accept(detail)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewModel.selectPhoneNumber()
        }

        let phoneNumberObservable = viewModel.selectedPhoneNumberURL.asObservable().subscribe(on: scheduler)
        let result = try phoneNumberObservable.toBlocking(timeout: 2.0).first()

        XCTAssertEqual(result, URL(string: "tel://0222428888"))

    }
}
