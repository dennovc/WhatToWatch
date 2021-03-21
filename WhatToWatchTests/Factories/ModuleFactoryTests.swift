//
//  ModuleFactoryTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 21.03.2021.
//

import XCTest
@testable import WhatToWatch

final class ModuleFactoryTests: XCTestCase {

    // MARK: - Prepare

    private var sut: ModuleFactory!

    override func setUp() {
        super.setUp()
        sut = ModuleFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testModuleFactoryConformsToModuleFactoryProtocol() {
        XCTAssertTrue((sut as AnyObject) is ModuleFactoryProtocol)
    }

}
