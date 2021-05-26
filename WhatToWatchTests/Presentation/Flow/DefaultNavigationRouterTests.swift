//
//  DefaultNavigationRouterTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 28.02.2021.
//

import XCTest
@testable import WhatToWatch

final class DefaultNavigationRouterTests: XCTestCase {

    // MARK: - Prepare

    private var sut: DefaultNavigationRouter!
    private var rootController: MockNavigationController!

    private var firstModule: UIViewController!
    private var secondModule: UIViewController!
    private var thirdModule: UIViewController!

    override func setUp() {
        super.setUp()

        rootController = MockNavigationController()
        sut = DefaultNavigationRouter(rootController: rootController)

        firstModule = UIViewController()
        secondModule = UIViewController()
        thirdModule = UIViewController()
    }

    override func tearDown() {
        sut = nil
        rootController = nil

        firstModule = nil
        secondModule = nil
        thirdModule = nil

        super.tearDown()
    }

    // MARK: - Tests

    func testPresentAnimatedFalseShouldPresentModuleWithoutAnimation() {
        sut.present(firstModule, animated: false)

        XCTAssertEqual(rootController.presentedController, firstModule)
        XCTAssertFalse(rootController.wasAnimated)
    }

    func testPresentShouldPresentModuleWithAnimation() {
        sut.present(firstModule)

        XCTAssertEqual(rootController.presentedController, firstModule)
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testDismissModuleAnimatedFalseShouldDismissModuleWithoutAnimation() {
        sut.present(firstModule)
        sut.dismissModule(animated: false)

        XCTAssertNil(rootController.presentedController)
        XCTAssertFalse(rootController.wasAnimated)
    }

    func testDismissModuleShouldDismissModuleWithAnimation() {
        sut.present(firstModule)
        sut.dismissModule()

        XCTAssertNil(rootController.presentedController)
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testPushAnimatedFalseShouldAppendModuleToNavigationStackWithoutAnimation() {
        sut.setRootModule(firstModule)

        sut.push(secondModule, animated: false)
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule])
        XCTAssertFalse(rootController.wasAnimated)

        sut.push(thirdModule, animated: false)
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule, thirdModule])
        XCTAssertFalse(rootController.wasAnimated)
    }

    func testPushShouldAppendModuleToNavigationStackWithAnimation() {
        sut.setRootModule(firstModule)

        sut.push(secondModule)
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule])
        XCTAssertTrue(rootController.wasAnimated)

        sut.push(thirdModule)
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule, thirdModule])
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testPopModuleAnimatedFalseShouldPopTopModuleFromNavigationStackWithoutAnimation() {
        sut.setRootModule(firstModule)
        sut.push(secondModule)
        sut.push(thirdModule)

        sut.popModule(animated: false)
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule])
        XCTAssertFalse(rootController.wasAnimated)

        sut.popModule(animated: false)
        XCTAssertEqual(rootController.navigationStack, [firstModule])
        XCTAssertFalse(rootController.wasAnimated)
    }

    func testPopModuleShouldPopTopModuleFromNavigationStackWithAnimation() {
        sut.setRootModule(firstModule)
        sut.push(secondModule)
        sut.push(thirdModule)

        sut.popModule()
        XCTAssertEqual(rootController.navigationStack, [firstModule, secondModule])
        XCTAssertTrue(rootController.wasAnimated)

        sut.popModule()
        XCTAssertEqual(rootController.navigationStack, [firstModule])
        XCTAssertTrue(rootController.wasAnimated)
    }

    func testSetRootModuleShouldSetNavigationStackWithModuleWithoutAnimation() {
        sut.setRootModule(firstModule)

        XCTAssertEqual(rootController.navigationStack, [firstModule])
        XCTAssertFalse(rootController.wasAnimated)
        XCTAssertFalse(rootController.navigationBarIsHidden)
    }

    func testSetRootModuleHideNavigationBarShouldSetNavigationStackWithModuleAndHideNavigationBarWithoutAnimation() {
        sut.setRootModule(firstModule, hideNavigationBar: true)

        XCTAssertEqual(rootController.navigationStack, [firstModule])
        XCTAssertFalse(rootController.wasAnimated)
        XCTAssertTrue(rootController.navigationBarIsHidden)
        XCTAssertFalse(rootController.wasAnimatedNavigationBarHiding)
    }

}

// MARK: - Mock Navigation Controller

private final class MockNavigationController: UINavigationController {

    // MARK: - Properties

    private(set) var wasAnimated = false
    private(set) var wasAnimatedNavigationBarHiding = false
    private(set) var navigationBarIsHidden = false
    private(set) var navigationStack = [UIViewController]()
    private(set) var presentedController: UIViewController?

    // MARK: - Methods

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        wasAnimated = flag
        presentedController = viewControllerToPresent
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        wasAnimated = flag
        presentedController = nil
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        wasAnimated = animated
        navigationStack.append(viewController)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        wasAnimated = animated
        return navigationStack.removeLast()
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        wasAnimated = animated
        navigationStack = viewControllers
    }

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        navigationBarIsHidden = hidden
        wasAnimatedNavigationBarHiding = animated
    }

}
