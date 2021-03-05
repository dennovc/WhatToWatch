//
//  RouterTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 28.02.2021.
//

import XCTest
@testable import WhatToWatch

final class RouterTests: XCTestCase {

    // MARK: - Prepare

    private var mockRootController: MockNavigationController!
    private var sut: Router!

    private var firstController: UIViewController!
    private var secondController: UIViewController!
    private var thirdController: UIViewController!

    override func setUp() {
        super.setUp()

        mockRootController = MockNavigationController()
        sut = Router(rootController: mockRootController)

        firstController = UIViewController()
        secondController = UIViewController()
        thirdController = UIViewController()
    }

    override func tearDown() {
        sut = nil
        mockRootController = nil

        firstController = nil
        secondController = nil
        thirdController = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testRouterConformsToRouterProtocol() {
        XCTAssertTrue((sut as AnyObject) is RouterProtocol)
    }

    func testInitByRootController() {
        XCTAssertTrue(mockRootController.navigationStack.isEmpty)
        XCTAssertNil(mockRootController.presentedController)
    }

    func testPresentModuleSetsPresentedModuleWithAnimation() {
        sut.present(firstController)

        XCTAssertEqual(mockRootController.presentedController, firstController)
        XCTAssertTrue(mockRootController.wasAnimated)
    }

    func testDismissModuleUnsetsPresentedModuleWithAnimation() {
        sut.present(firstController)
        sut.dismissModule()

        XCTAssertNil(mockRootController.presentedController)
        XCTAssertTrue(mockRootController.wasAnimated)
    }

    func testSetRootModuleSetsNavigationStackWithModuleWithoutAnimation() {
        sut.setRootModule(firstController)

        XCTAssertEqual(mockRootController.navigationStack, [firstController])
        XCTAssertFalse(mockRootController.wasAnimated)
        XCTAssertFalse(mockRootController.navigationBarIsHidden)
    }

    func testSetRootModuleSetsNavigationStackWithModuleAndHidesNavigationBarWithoutAnimation() {
        sut.setRootModule(firstController, hideNavigationBar: true)

        XCTAssertEqual(mockRootController.navigationStack, [firstController])
        XCTAssertFalse(mockRootController.wasAnimated)
        XCTAssertTrue(mockRootController.navigationBarIsHidden)
        XCTAssertFalse(mockRootController.wasAnimatedNavigationBarHiding)
    }

    func testPushModuleAppendsModuleToNavigationStackWithAnimation() {
        sut.setRootModule(firstController)

        sut.push(secondController)
        XCTAssertEqual(mockRootController.navigationStack, [firstController, secondController])

        sut.push(thirdController)
        XCTAssertEqual(mockRootController.navigationStack, [firstController, secondController, thirdController])

        XCTAssertTrue(mockRootController.wasAnimated)
    }

    func testPopModulePopsTopModuleFromNavigationStackWithAnimation() {
        sut.setRootModule(firstController)
        sut.push(secondController)
        sut.push(thirdController)

        sut.popModule()
        XCTAssertEqual(mockRootController.navigationStack, [firstController, secondController])

        sut.popModule()
        XCTAssertEqual(mockRootController.navigationStack, [firstController])

        XCTAssertTrue(mockRootController.wasAnimated)
    }

}
