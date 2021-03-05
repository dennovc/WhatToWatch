//
//  CoordinatorFactoryTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

import XCTest
@testable import WhatToWatch

final class CoordinatorFactoryTests: XCTestCase {

    // MARK: - Prepare

    private var sut: CoordinatorFactory!

    override func setUp() {
        super.setUp()
        sut = CoordinatorFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testMakeTabBarCoordinatorReturnsTabBarCoordinatorAndTabBarController() {
        let (coordinator, module) = sut.makeTabBarCoordinator()

        XCTAssertTrue(coordinator is TabBarCoordinator)
        XCTAssertTrue(module is TabBarController)
    }

    func testMakeSearchCoordinatorReturnsSearchCoordinator() {
        let coordinator = sut.makeSearchCoordinator(router: MockRouter())
        XCTAssertTrue(coordinator is SearchCoordinator)
    }

}
