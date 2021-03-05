//
//  AppCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class AppCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private let router: RouterProtocol
    private let coordinatorSupplier: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(router: RouterProtocol, coordinatorSupplier: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorSupplier = coordinatorSupplier

        super.init()
    }

    // MARK: - Methods

    override func start() {
        runTabBarCoordinator()
    }

    // MARK: - Private Methods

    private func runTabBarCoordinator() {
        let (coordinator, module) = coordinatorSupplier.makeTabBarCoordinator()

        addDependency(coordinator)
        coordinator.start()

        router.setRootModule(module, hideNavigationBar: true)
    }

}
