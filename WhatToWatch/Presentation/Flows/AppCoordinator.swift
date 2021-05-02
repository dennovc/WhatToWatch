//
//  AppCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation
import Swinject

final class AppCoordinator: BaseFlowCoordinator {

    // MARK: - Private Properties

    private let router: NavigationRouter
    private let coordinatorProvider: FlowCoordinatorProvider

    init(router: NavigationRouter, diContainer: Container) {
        self.router = router
        self.coordinatorProvider = diContainer.resolve(FlowCoordinatorProvider.self)!

        super.init()
    }

    // MARK: - Methods

    override func start() {
        runTabBarCoordinator()
    }

    // MARK: - Private Methods

    private func runTabBarCoordinator() {
        let (coordinator, module) = coordinatorProvider.makeTabBarCoordinator()

        addDependency(coordinator)
        coordinator.start()

        router.setRootModule(module, hideNavigationBar: true)
    }

}
