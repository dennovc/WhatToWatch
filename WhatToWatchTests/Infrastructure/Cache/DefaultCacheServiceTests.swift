//
//  DefaultCacheServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 21.04.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultCacheServiceTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultCacheService<Int, String>!

    override func setUp() {
        super.setUp()
        sut = DefaultCacheService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testValueThereIsValueForKeyShouldReturnValue() {
        sut.insert("Foo", forKey: 1)
        let value = sut.value(forKey: 1)
        XCTAssertEqual(value, "Foo")
    }

    func testValueThereIsNoValueForKeyShouldReturnNil() {
        let value = sut.value(forKey: 1)
        XCTAssertNil(value)
    }

    func testRemoveValueShouldRemoveValue() {
        sut.insert("Foo", forKey: 1)
        sut.removeValue(forKey: 1)
        let value = sut.value(forKey: 1)
        XCTAssertNil(value)
    }

    func testSubscriptThereIsValueForKeyShouldReturnValue() {
        sut.insert("Foo", forKey: 1)
        let value = sut[1]
        XCTAssertEqual(value, "Foo")
    }

    func testSubscriptThereIsNoValueForKeyShouldReturnNil() {
        let value = sut[1]
        XCTAssertNil(value)
    }

    func testSubscriptSetNilShouldRemoveValue() {
        sut.insert("Foo", forKey: 1)
        sut[1] = nil
        let value = sut.value(forKey: 1)
        XCTAssertNil(value)
    }

    func testSubscriptSetValueShouldSetValue() {
        sut[1] = "Foo"
        let value = sut.value(forKey: 1)
        XCTAssertEqual(value, "Foo")
    }

}
