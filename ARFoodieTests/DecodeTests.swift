//
//  DecodeTests.swift
//  ARFoodieTests
//
//  Created by Barry Chen on 2021/4/1.
//  Copyright © 2021 Chen Yi-Wei. All rights reserved.
//

import XCTest
@testable import ARFoodie

class DecodeTests: XCTestCase {
    private func cachedFileData(name: String, ext: String = "json") -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: name, ofType: ext) else {
            print("File not found.")
            return nil
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            print("Create data error.")
            return nil
        }
        return data
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_decode_restaurants() throws {
        guard let data = cachedFileData(name: "nearby_places") else {
            XCTFail("File not found")
            return
        }

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "results"

        let envelope = try decoder.decode(GooglePlacesEnvelope<[Restaurant]>.self, from: data)

        XCTAssertFalse(envelope.content.isEmpty)
    }

    func test_decode_restaurantDetail() throws {
        guard let data = cachedFileData(name: "place_detail") else {
            XCTFail("File not found")
            return
        }

        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = "result"

        let envelope = try decoder.decode(GooglePlacesEnvelope<RestaurantDetail>.self, from: data)
        XCTAssertEqual("皇星魚翅餐廳", envelope.content.name)
    }
}
