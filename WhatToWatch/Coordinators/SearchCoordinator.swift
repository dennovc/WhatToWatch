//
//  SearchCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class SearchCoordinator: BaseFlowCoordinator {

    // MARK: - Private Properties

    private let router: NavigationRouter
    private let moduleSupplier: ModuleFactoryProtocol
    private let coordinatorSupplier: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(router: NavigationRouter,
         moduleSupplier: ModuleFactoryProtocol,
         coordinatorSupplier: CoordinatorFactoryProtocol) {
        self.router = router
        self.moduleSupplier = moduleSupplier
        self.coordinatorSupplier = coordinatorSupplier

        super.init()
    }

    // MARK: - Methods

    override func start() {
        showSearchModule()
    }

    // MARK: - Private Methods

    private func showSearchModule() {
        let (route, module) = moduleSupplier.makeSearchModule()

        route.showDetail = { [weak self] type, id in
            self?.runDetailCoordinator(itemType: type, itemID: id)
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
