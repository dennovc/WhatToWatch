//
//  TabBarController.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

final class TabBarController: UITabBarController, TabBarRoute {

    // MARK: - Route

    var onStart: ((RouterProtocol) -> Void)?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRoute()
    }

    // MARK: - Private Methods

    private func configureTabs() {
        let searchTab = makeSearchTab()
        setViewControllers([searchTab], animated: false)
    }

    private func makeSearchTab() -> UINavigationController {
        let tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let controller = UINavigationController()
        controller.tabBarItem = tabBarItem

        return controller
    }

    private func startRoute() {
        guard let controller = selectedViewController as? UINavigationController,
              controller.viewControllers.isEmpty
        else { return }

        let router = Router(rootController: controller)
        onStart?(router)
    }

}
