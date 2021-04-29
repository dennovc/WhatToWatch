//
//  SearchCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation
import Swinject

final class SearchCoordinator: BaseFlowCoordinator {

    // MARK: - Private Properties

    private let router: NavigationRouter
    private let moduleSupplier: ModuleFactoryProtocol
    private let coordinatorSupplier: FlowCoordinatorProvider

    // MARK: - Life Cycle

    init(router: NavigationRouter,
         diContainer: Container) {
        self.router = router
        self.moduleSupplier = diContainer.resolve(ModuleFactoryProtocol.self)!
        self.coordinatorSupplier = diContainer.resolve(FlowCoordinatorProvider.self)!

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

    private func runDetailCoordinator(itemType: MediaType, itemID: Int) {
        let coordinator = coordinatorSupplier.makeDetailCoordinator(mediaType: itemType,
                                                                    mediaID: itemID,
                                                                    router: router)

        addDependency(coordinator)

        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }

        coordinator.start()
    }

}
