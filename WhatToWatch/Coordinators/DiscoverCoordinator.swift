//
//  DiscoverCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 13.04.2021.
//

import Foundation
import Swinject

final class DiscoverCoordinator: BaseFlowCoordinator {

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

        route.onError = { [unowned self] errorText in
            let module = moduleSupplier.makeMessageAlertModule(title: "Error", message: errorText)
            self.router.present(module)
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
