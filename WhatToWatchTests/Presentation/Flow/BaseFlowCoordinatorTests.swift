//
//  BaseFlowCoordinatorTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 02.03.2021.
//

import XCTest
@testable import WhatToWatch

final class BaseFlowCoordinatorTests: XCTestCase {

    // MARK: - Prepare

    private var sut: BaseFlowCoordinator!

    private var firstCoordinator: MockCoordinator!
    private var secondCoordinator: MockCoordinator!

    private weak var weakLinkToFirstCoordinator: MockCoordinator?
    private weak var weakLinkToSecondCoordinator: MockCoordinator?

    override func setUp() {
        super.setUp()

        sut = BaseFlowCoordinator()

        firstCoordinator = MockCoordinator()
        secondCoordinator = MockCoordinator()

        weakLinkToFirstCoordinator = firstCoordinator
        weakLinkToSecondCoordinator = secondCoordinator
    }

    override func tearDown() {
        sut = nil

        firstCoordinator = nil
        secondCoordinator = nil

        weakLinkToFirstCoordinator = nil
        weakLinkToSecondCoordinator = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testAddDependencyShouldSaveCoordinator() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(secondCoordinator)

        firstCoordinator = nil
        secondCoordinator = nil

        XCTAssertNotNil(weakLinkToFirstCoordinator)
        XCTAssertNotNil(weakLinkToSecondCoordinator)
    }

    func testAddDependencyShouldSaveOnlyUniqueReference() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(firstCoordinator)

        sut.removeDependency(firstCoordinator)
        firstCoordinator = nil

        XCTAssertNil(weakLinkToFirstCoordinator)
    }

    func testAddDependencyShouldDoNotSaveItself() {
        weak var weakLinkToSut = sut
        sut.addDependency(sut)
        sut = nil

        XCTAssertNil(weakLinkToSut)
    }

    func testRemoveDependencyShouldDeleteCoordinator() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(secondCoordinator)

        sut.removeDependency(firstCoordinator)
        sut.removeDependency(secondCoordinator)

        firstCoordinator = nil
        secondCoordinator = nil

        XCTAssertNil(weakLinkToFirstCoordinator)
        XCTAssertNil(weakLinkToSecondCoordinator)
    }

}

// MARK: - Mock Coordinator

private final class MockCoordinator: FlowCoordinator {

    func start() {}

}
