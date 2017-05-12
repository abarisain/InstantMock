//
//  DefaultValueHandlerTests.swift
//  InstantMock
//
//  Created by Patrick on 12/05/2017.
//  Copyright © 2017 pirishd. All rights reserved.
//


import XCTest
@testable import InstantMock


class DummyDefaultValueHandler {}


class DefaultValueHandlerTests: XCTestCase {

    func testIt_notMockUsable() {
        let defaultValueHandler = DefaultValueHandler<DummyDefaultValueHandler>()
        XCTAssertNil(defaultValueHandler.it)
    }


    func testIt_string() {
        let defaultValueHandler = DefaultValueHandler<String>()
        XCTAssertEqual(defaultValueHandler.it, String.any)
    }

    func testIt_closure() {
        let defaultValueHandler = DefaultValueHandler<Closure>()
        XCTAssertNotNil(defaultValueHandler.it)
    }

}