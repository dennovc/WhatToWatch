//
//  TabBarController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

final class TabBarController: UITabBarController, TabBarRoute {

    // MARK: - Route

    var onStart: ((UINavigationController) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let controller = customizableViewControllers?.first as? UINavigationController {
            onStart?(controller)
        }
    }

    // MARK: - Private Methods

    private func configureTabBar() {
        let searchTab = makeSearchTab()

        setViewControllers([searchTab], animated: false)
    }

    private func makeSearchTab() -> UINavigationController {
        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let controller = UINavigationController()
        controller.tabBarItem = searchTabBarItem

        return controller
    }

}
