//
//  SearchCoordinatorTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 21.03.2021.
//

import XCTest
@testable import WhatToWatch

final class SearchCoordinatorTests: XCTestCase {

    // MARK: - Prepare

    private var router: MockRouter!
    private var moduleSupplier: MockModuleFactory!
    private var coordinatorSupplier: MockCoordinatorFactory!
    private var sut: SearchCoordinator!

    override func setUp() {
        super.setUp()

        router = MockRouter()
        moduleSupplier = MockModuleFactory()
        coordinatorSupplier = MockCoordinatorFactory()
        
        sut = SearchCoordinator(router: router,
                                moduleSupplier: moduleSupplier,
                                coordinatorSupplier: coordinatorSupplier)
    }

    override func tearDown() {
        sut = nil
        router = nil
        moduleSupplier = nil
        coordinatorSupplier = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testSearchCoordinatorConformsToCoordinatorProtocol() {
        XCTAssertTrue((sut as AnyObject) is CoordinatorProtocol)
    }

}
