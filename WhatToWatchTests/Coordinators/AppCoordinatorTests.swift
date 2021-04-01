//
//  AppCoordinatorTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

import XCTest
@testable import WhatToWatch

final class AppCoordinatorTests: XCTestCase {

    // MARK: - Prepare

    private var router: MockRouter!
    private var coordinatorSupplier: MockCoordinatorFactory!
    private var sut: AppCoordinator!

    override func setUp() {
        super.setUp()

        router = MockRouter()
        coordinatorSupplier = MockCoordinatorFactory()
        sut = AppCoordinator(router: router, coordinatorSupplier: coordinatorSupplier)
    }

    override func tearDown() {
        sut = nil
        router = nil
        coordinatorSupplier = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testAppCoordinatorConformsToCoordinatorProtocol() {
        XCTAssertTrue((sut as AnyObject) is CoordinatorProtocol)
    }

    func testStartRunsCoordinator() {
        sut.start()

        XCTAssertNotNil(coordinatorSupplier.returnedCoordinator)
        XCTAssertTrue(coordinatorSupplier.returnedCoordinator!.didStart)
        XCTAssertTrue(coordinatorSupplier.returnedModule === router.navigationStack.first)
        XCTAssertTrue(router.navigationBarIsHidden)
    }

}
