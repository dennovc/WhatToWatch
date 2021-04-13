//
//  DiscoverCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

final class DiscoverCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private let router: RouterProtocol
    private let moduleSupplier: ModuleFactoryProtocol
    private let coordinatorSupplier: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(router: RouterProtocol,
         moduleSupplier: ModuleFactoryProtocol,
         coordinatorSupplier: CoordinatorFactoryProtocol) {
        self.router = router
        self.moduleSupplier = moduleSupplier
        self.coordinatorSupplier = coordinatorSupplier

        super.init()
    }

    // MARK: - Methods

    override func start() {
        showDiscoverModule()
    }

    // MARK: - Private Methods

    private func showDiscoverModule() {
        let (route, module) = moduleSupplier.makeDiscoverModule()

        route.showDetail = { [weak self] type, id in
            self?.runDetailCoordinator(itemType: type, itemID: id)
        }

        let loadModule = moduleSupplier.makeLoadModule()
        router.present(loadModule)

        route.loading = { [weak self] isLoading in
            guard isLoading else {
                self?.router.dismissModule()
                return
            }

        }

        router.setRootModule(module)
    }

    private func runDetailCoordinator(itemType: ScopeButton, itemID: Int) {
        let coordinator = coordinatorSupplier.makeDetailCoordinator(itemType: itemType,
                                                                    itemID: itemID,
                                                                    router: router)

        addDependency(coordinator)

        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }

        coordinator.start()
    }

}
