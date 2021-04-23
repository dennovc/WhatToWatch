//
//  AnyCacheServiceTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.04.2021.
//

import XCTest
@testable import WhatToWatch

final class AnyCacheServiceTests: XCTestCase {

    // MARK: - Prepare

    private var sut: AnyCacheService<Int, String>!
    private var cacheService: MockCacheService!

    override func setUp() {
        super.setUp()

        cacheService = MockCacheService()
        sut = AnyCacheService(cacheService)
    }

    override func tearDown() {
        sut = nil
        cacheService = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testInsertShouldSetValue() {
        sut.insert("Foo", forKey: 1)
        XCTAssertEqual(cacheService.container, [1: "Foo"])
    }

    func testValueThereIsValueForKeyShouldReturnValue() {
        cacheService.insert("Foo", forKey: 1)
        let value = sut.value(forKey: 1)
        XCTAssertEqual(value, "Foo")
    }

    func testValueThereIsNoValueForKeyShouldReturnNil() {
        let value = sut.value(forKey: 1)
        XCTAssertNil(value)
    }

    func testRemoveValueShouldRemoveValue() {
        cacheService.insert("Foo", forKey: 1)
        sut.removeValue(forKey: 1)
        XCTAssertTrue(cacheService.container.isEmpty)
    }

    func testSubscriptThereIsValueForKeyShouldReturnValue() {
        cacheService.insert("Foo", forKey: 1)
        let value = sut[1]
        XCTAssertEqual(value, "Foo")
    }

    func testSubscriptThereIsNoValueForKeyShouldReturnNil() {
        let value = sut[1]
        XCTAssertNil(value)
    }

    func testSubscriptSetNilShouldRemoveValue() {
        cacheService.insert("Foo", forKey: 1)
        sut[1] = nil
        XCTAssertTrue(cacheService.container.isEmpty)
    }

    func testSubscriptSetValueShouldSetValue() {
        sut[1] = "Foo"
        XCTAssertEqual(cacheService.container, [1: "Foo"])
    }

}

// MARK: - Mock Cache Service

private final class MockCacheService: CacheService {

    typealias Key = Int
    typealias Value = String

    private(set) var container = [Key: Value]()

    func insert(_ value: Value, forKey key: Key) {
        container[key] = value
    }

    func value(forKey key: Key) -> Value? {
        return container[key]
    }

    func removeValue(forKey key: Key) {
        container[key] = nil
    }

    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }

}
