//
//  TabBarController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

final class TabBarController: UITabBarController, TabBarRoute {

    // MARK: - Routing

    var onStart: ((NavigationRouter) -> Void)?
    var onDiscoverSelect: ((NavigationRouter) -> Void)?
    var onSearchSelect: ((NavigationRouter) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRoute()
    }

    // MARK: - Private Methods

    private func configureTabs() {
        let discoverTab = makeDiscoverTab()
        let searchTab = makeSearchTab()

        let tabs = [
            discoverTab,
            searchTab
        ]

        setViewControllers(tabs, animated: false)
    }

    private func makeSearchTab() -> UINavigationController {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: "Search",
                                             image: UIImage(systemName: "magnifyingglass"),
                                             selectedImage: UIImage(systemName: "magnifyingglass"))

        return controller
    }

    private func makeDiscoverTab() -> UINavigationController {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: "Discover",
                                             image: UIImage(systemName: "tv"),
                                             selectedImage: UIImage(systemName: "tv"))

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

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let controller = viewController as? UINavigationController,
            controller.viewControllers.isEmpty
        else { return }

        switch selectedIndex {
        case 0: onDiscoverSelect?(DefaultNavigationRouter(rootController: controller))
        case 1: onSearchSelect?(DefaultNavigationRouter(rootController: controller))
        default: break
        }
    }

}
