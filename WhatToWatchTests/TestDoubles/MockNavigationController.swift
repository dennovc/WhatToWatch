//
//  MockNavigationController.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 28.02.2021.
//

import UIKit

final class MockNavigationController: UINavigationController {

    // MARK: - Properties

    private(set) var wasAnimated = false
    private(set) var wasAnimatedNavigationBarHiding = false
    private(set) var navigationBarIsHidden = false
    private(set) var navigationStack = [UIViewController]()
    private(set) var presentedController: UIViewController?

    // MARK: - Overridden Properties

    override var viewControllers: [UIViewController] {
        get { navigationStack }
        set { navigationStack = newValue }
    }

    override var isNavigationBarHidden: Bool {
        get { navigationBarIsHidden }
        set { navigationBarIsHidden = newValue }
    }

    // MARK: - Overridden Methods

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentedController = viewControllerToPresent
        wasAnimated = flag
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedController = nil
        wasAnimated = flag
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationStack.append(viewController)
        wasAnimated = animated
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        wasAnimated = animated
        return navigationStack.removeLast()
    }

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        navigationStack = viewControllers
        wasAnimated = animated
    }

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        navigationBarIsHidden = hidden
        wasAnimatedNavigationBarHiding = animated
    }

}
