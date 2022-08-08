//
//  SharedTestHelpers.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/8/4.
//

import Foundation

func anyError() -> NSError {
    .init(domain: "Test", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://any.com")!
}
