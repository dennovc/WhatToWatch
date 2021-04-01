//
//  TabBarCoordinatorTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 21.03.2021.
//

import XCTest
@testable import WhatToWatch

final class TabBarCoordinatorTests: XCTestCase {

    // MARK: - Prepare

    private var route: MockTabBarRoute!
    private var coordinatorSupplier: MockCoordinatorFactory!
    private var router: MockRouter!
    private var sut: TabBarCoordinator!

    override func setUp() {
        super.setUp()

        route = MockTabBarRoute()
        coordinatorSupplier = MockCoordinatorFactory()
        router = MockRouter()
        sut = TabBarCoordinator(route: route, coordinatorSupplier: coordinatorSupplier)
    }

    override func tearDown() {
        sut = nil
        route = nil
        coordinatorSupplier = nil
        router = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testTabBarCoordinatorConformsToCoordinatorProtocol() {
        XCTAssertTrue((sut as AnyObject) is CoordinatorProtocol)
    }

    func testStartRunsCoordinator() {
        sut.start()
        route.onStart?(router)

        XCTAssertNotNil(route.onStart)
        XCTAssertNotNil(coordinatorSupplier.returnedCoordinator)
        XCTAssertTrue(coordinatorSupplier.returnedCoordinator!.didStart)
        XCTAssertTrue(coordinatorSupplier.receivedRouter === router)
    }

}

// MARK: - Mock Classes

extension TabBarCoordinatorTests {

    private final class MockTabBarRoute: TabBarRoute {

        var onStart: ((RouterProtocol) -> Void)?

    }

}
