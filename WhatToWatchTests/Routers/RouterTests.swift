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

    private var rootController: MockNavigationController!
    private var sut: Router!

    private var firstController: UIViewController!
    private var secondController: UIViewController!
    private var thirdController: UIViewController!

    override func setUp() {
        super.setUp()

        rootController = MockNavigationController()
        sut = Router(rootController: rootController)

        firstController = UIViewController()
        secondController = UIViewController()
        thirdController = UIViewController()
    }

    override func tearDown() {
        sut = nil
        rootController = nil

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
        XCTAssertTrue(rootController.navigationStack.isEmpty)
        XCTAssertNil(rootController.presentedController)
    }

    func testPresentModuleSetsPresentedModuleWithAnimation() {
        sut.present(firstController)

        XCTAssertEqual(rootController.presentedController, firstController)
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testDismissModuleUnsetsPresentedModuleWithAnimation() {
        sut.present(firstController)
        sut.dismissModule()

        XCTAssertNil(rootController.presentedController)
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testSetRootModuleSetsNavigationStackWithModuleWithoutAnimation() {
        sut.setRootModule(firstController)

        XCTAssertEqual(rootController.navigationStack, [firstController])
        XCTAssertFalse(rootController.wasAnimated)
        XCTAssertFalse(rootController.navigationBarIsHidden)
    }

    func testSetRootModuleSetsNavigationStackWithModuleAndHidesNavigationBarWithoutAnimation() {
        sut.setRootModule(firstController, hideNavigationBar: true)

        XCTAssertEqual(rootController.navigationStack, [firstController])
        XCTAssertFalse(rootController.wasAnimated)
        XCTAssertTrue(rootController.navigationBarIsHidden)
        XCTAssertFalse(rootController.wasAnimatedNavigationBarHiding)
    }

    func testPushModuleAppendsModuleToNavigationStackWithAnimation() {
        sut.setRootModule(firstController)

        sut.push(secondController)
        XCTAssertEqual(rootController.navigationStack, [firstController, secondController])

        sut.push(thirdController)
        XCTAssertEqual(rootController.navigationStack, [firstController, secondController, thirdController])

        XCTAssertTrue(rootController.wasAnimated)
    }

    func testPopModulePopsTopModuleFromNavigationStackWithAnimation() {
        sut.setRootModule(firstController)
        sut.push(secondController)
        sut.push(thirdController)

        sut.popModule()
        XCTAssertEqual(rootController.navigationStack, [firstController, secondController])

        sut.popModule()
        XCTAssertEqual(rootController.navigationStack, [firstController])

        XCTAssertTrue(rootController.wasAnimated)
    }

}
