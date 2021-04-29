//
//  TabBarCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation
import Swinject

final class TabBarCoordinator: BaseFlowCoordinator {

    // MARK: - Private Properties

    private weak var route: TabBarRoute?
    private let coordinatorProvider: FlowCoordinatorProvider

    init(route: TabBarRoute, diContainer: Container) {
        self.route = route
        self.coordinatorProvider = diContainer.resolve(FlowCoordinatorProvider.self)!

        super.init()
    }

    // MARK: - Methods

    override func start() {
        route?.onStart = runDiscoverCoordinator()
        route?.onDiscoverSelect = runDiscoverCoordinator()
        route?.onSearchSelect = runSearchCoordinator()
    }

    // MARK: - Private Methods

    private func runCoordinator(_ coordinator: FlowCoordinator) {
        addDependency(coordinator)
        coordinator.start()
    }

    private func runDiscoverCoordinator() -> ((NavigationRouter) -> Void) {
        return { [weak self] router in
            guard let self = self else { return }

            let coordinator = self.coordinatorProvider.makeDiscoverCoordinator(router: router)
            self.runCoordinator(coordinator)
        }
    }

    private func runSearchCoordinator() -> ((NavigationRouter) -> Void) {
        return { [weak self] router in
            guard let self = self else { return }

            let coordinator = self.coordinatorProvider.makeSearchCoordinator(router: router)
            self.runCoordinator(coordinator)
        }
    }

}
