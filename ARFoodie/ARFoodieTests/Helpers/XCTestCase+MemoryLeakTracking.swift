//
//  XCTestCase+MemoryLeakTracking.swift
//  ARFoodieTests
//
//  Created by Chen Yi-Wei on 2022/8/4.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
