//
//  TabBarController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

private enum Tab: Int, CaseIterable {

    case discover
    case search

}

final class TabBarController: UITabBarController, TabBarRoute {

    // MARK: - Routing

    var onStart: ((NavigationRouter) -> Void)?
    var onDiscoverSelect: ((NavigationRouter) -> Void)?
    var onSearchSelect: ((NavigationRouter) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        delegating()
        configureTabs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRoute()
    }

    // MARK: - Private Methods

    private func delegating() {
        delegate = self
    }

    private func configureTabs() {
        let tabs = Tab.allCases.map { tab -> UIViewController in
            switch tab {
            case .discover: return makeDiscoverTab()
            case .search: return makeSearchTab()
            }
        }

        setViewControllers(tabs, animated: false)
    }

    private func makeDiscoverTab() -> UIViewController {
        let controller = UINavigationController()
        let icon = UIImage(systemName: "tv")

        controller.tabBarItem = .init(title: "Discover",
                                      image: icon,
                                      selectedImage: icon)

        return controller
    }

    private func makeSearchTab() -> UIViewController {
        let controller = UINavigationController()
        let icon = UIImage(systemName: "magnifyingglass")

        controller.tabBarItem = .init(title: "Search",
                                      image: icon,
                                      selectedImage: icon)

        return controller
    }

    private func startRoute() {
        guard let controller = selectedViewController as? UINavigationController,
              controller.viewControllers.isEmpty
        else { return }

        let router = DefaultNavigationRouter(rootController: controller)
        onStart?(router)
    }

}

// MARK: - Tab Bar Controller Delegate

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let controller = viewController as? UINavigationController,
            controller.viewControllers.isEmpty,
            let tab = Tab(rawValue: selectedIndex)
        else { return }

        let router = DefaultNavigationRouter(rootController: controller)

        switch tab {
        case .discover: onDiscoverSelect?(router)
        case .search: onSearchSelect?(router)
        }
    }

}
