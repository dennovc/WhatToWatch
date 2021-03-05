//
//  TabBarCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class TabBarCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private weak var route: TabBarRoute?
    private let coordinatorSupplier: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(route: TabBarRoute, coordinatorSupplier: CoordinatorFactoryProtocol) {
        self.route = route
        self.coordinatorSupplier = coordinatorSupplier

        super.init()
    }

    // MARK: - Methods

    override func start() {
        route?.onStart = runSearchCoordinator()
    }

    // MARK: - Private Methods

    private func runSearchCoordinator() -> ((RouterProtocol) -> Void) {
        return { [weak self] router in
            guard let coordinator = self?.coordinatorSupplier.makeSearchCoordinator(router: router) else { return }

            self?.addDependency(coordinator)
            coordinator.start()
        }
    }

}
