//
//  TabBarControllerTests.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 23.03.2021.
//

import XCTest
@testable import WhatToWatch

final class TabBarControllerTests: XCTestCase {

    // MARK: - Prepare

    private var sut: TabBarController!

    override func setUp() {
        super.setUp()
        sut = TabBarController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testDefaultInitRouteIsNil() {
        XCTAssertNil(sut.onStart)
    }

    func testAfterViewDidLoadTabsAreConfigured() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.viewControllers)
        XCTAssertFalse(sut.viewControllers!.isEmpty)
    }

    func testViewWillAppearStartsRoute() {
        var didStart = false

        sut.onStart = { _ in
            didStart = true
        }

        sut.beginAppearanceTransition(true, animated: false)

        XCTAssertTrue(didStart)
    }

    func testOnStartIsNotCalledIfRouterHasModule() {
        var numberOfOnStartCalls = 0
        let module = UIViewController()

        sut.onStart = { router in
            numberOfOnStartCalls += 1
            router.setRootModule(module)
        }

        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.beginAppearanceTransition(false, animated: false)
        sut.endAppearanceTransition()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        XCTAssertEqual(numberOfOnStartCalls, 1)
    }

}
