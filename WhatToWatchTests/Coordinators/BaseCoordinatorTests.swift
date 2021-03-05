//
//  BaseCoordinatorTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 02.03.2021.
//

import XCTest
@testable import WhatToWatch

final class BaseCoordinatorTests: XCTestCase {

    // MARK: - Prepare

    private var sut: BaseCoordinator!

    private var firstCoordinator: BaseCoordinator!
    private var secondCoordinator: BaseCoordinator!

    private weak var weakLinkToFirstCoordinator: CoordinatorProtocol?
    private weak var weakLinkToSecondCoordinator: CoordinatorProtocol?

    override func setUp() {
        super.setUp()

        sut = BaseCoordinator()

        firstCoordinator = BaseCoordinator()
        secondCoordinator = BaseCoordinator()

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

    func testBaseCoordinatorConformsToCoordinatorProtocol() {
        XCTAssertTrue((sut as AnyObject) is CoordinatorProtocol)
    }

    func testStartDoingNothing() {
        XCTAssertNoThrow(sut.start())
    }

    func testAddDependencySavesCoordinators() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(secondCoordinator)

        firstCoordinator = nil
        secondCoordinator = nil

        XCTAssertNotNil(weakLinkToFirstCoordinator)
        XCTAssertNotNil(weakLinkToSecondCoordinator)
    }

    func testAddDependencySavesOnlyUniqueReferences() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(firstCoordinator)

        sut.removeDependency(firstCoordinator)
        firstCoordinator = nil

        XCTAssertNil(weakLinkToFirstCoordinator)
    }

    func testAddDependencyDoesNotSaveItself() {
        firstCoordinator.addDependency(firstCoordinator)
        firstCoordinator = nil

        XCTAssertNil(weakLinkToFirstCoordinator)
    }

    func testRemoveDependencyDeletesCoordinators() {
        sut.addDependency(firstCoordinator)
        sut.addDependency(secondCoordinator)

        firstCoordinator = nil
        secondCoordinator = nil

        sut.removeDependency(weakLinkToFirstCoordinator!)
        XCTAssertNil(weakLinkToFirstCoordinator)

        sut.removeDependency(weakLinkToSecondCoordinator!)
        XCTAssertNil(weakLinkToSecondCoordinator)
    }

    func testRemoveDependencyRemovesDependenciesRecursively() {
        firstCoordinator.addDependency(secondCoordinator)
        secondCoordinator = nil

        sut.addDependency(firstCoordinator)
        sut.removeDependency(firstCoordinator)

        XCTAssertNil(weakLinkToSecondCoordinator)
    }

}
