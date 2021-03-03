//
//  TabBarCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private let tabBarRoute: TabBarRoute
    private let supplierOfCoordinators: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(tabBarRoute: TabBarRoute, supplierOfCoordinators: CoordinatorFactoryProtocol) {
        self.tabBarRoute = tabBarRoute
        self.supplierOfCoordinators = supplierOfCoordinators

        super.init()
    }

    // MARK: - Methods

    override func start() {
        tabBarRoute.onStart = runSearchCoordinator()
    }

    // MARK: - Private Methods

    private func runSearchCoordinator() -> ((UINavigationController) -> Void) {
        return { [unowned self] rootController in
            guard rootController.viewControllers.isEmpty else { return }

            let coordinator = self.supplierOfCoordinators.makeSearchCoordinator(rootController: rootController)
            self.addDependency(coordinator)

            coordinator.start()
        }
    }

}
