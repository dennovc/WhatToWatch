//
//  NavigationRouter.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import Foundation

/// Defines a stack-based scheme for navigating hierarchical content.
protocol NavigationRouter {

    /**
     Presents a module modally with animation.

     - Parameter module: The module to display over the current module's content.
     */
    func present(_ module: Presentable)

    /**
     Presents a module modally.

     - Parameters:
        - module: The module to display over the current module's content.
        - animated: Pass `true` to animate the presentation; otherwise, pass `false`.
     */
    func present(_ module: Presentable, animated: Bool)

    /**
     Dismisses the module that was presented modally with animation.
     */
    func dismissModule()

    /**
     Dismisses the module that was presented modally.

     - Parameter animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
     */
    func dismissModule(animated: Bool)

    /**
     Pushes a module onto the receiver’s stack and updates the display with animation.

     - Parameter module: The module to push onto the stack.
     */
    func push(_ module: Presentable)

    /**
     Pushes a module onto the receiver’s stack and updates the display.

     - Parameters:
        - module: The module to push onto the stack.
        - animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
     */
    func push(_ module: Presentable, animated: Bool)

    /**
     Pops the top module from the navigation stack and updates the display with animation.
     */
    func popModule()

    /**
     Pops the top module from the navigation stack and updates the display.

     - Parameter animated: Specify `true` to animate the transition or `false` if you do not want the transition to be animated.
     */
    func popModule(animated: Bool)

    /**
     Clears the navigation stack and and pushing a module there.

     - Parameter module: The module that resides at the bottom of the navigation stack.
     */
    func setRootModule(_ module: Presentable)

    /**
     Clears the navigation stack and and pushing a module there.

     - Parameters:
        - module: The module that resides at the bottom of the navigation stack.
        - hideNavigationBar: Indicates whether to hide the navigation bar.
     */
    func setRootModule(_ module: Presentable, hideNavigationBar: Bool)

}

// MARK: - Default Implementation

extension NavigationRouter {

    func present(_ module: Presentable) {
        present(module, animated: true)
    }

    func dismissModule() {
        dismissModule(animated: true)
    }

    func push(_ module: Presentable) {
        push(module, animated: true)
    }

    func popModule() {
        popModule(animated: true)
    }

    func setRootModule(_ module: Presentable) {
        setRootModule(module, hideNavigationBar: false)
    }

}
