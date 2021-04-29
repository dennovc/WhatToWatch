//
//  DetailCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation
import Swinject

final class DetailCoordinator: BaseFlowCoordinator, DetailCoordinatorOutput {

    // MARK: Output

    var finishFlow: (() -> Void)?

    // MARK: - Private Properties

    private let itemType: MediaType
    private let itemID: Int
    private let router: NavigationRouter
    private let moduleSupplier: ModuleFactoryProtocol
    private let coordinatorSupplier: FlowCoordinatorProvider

    // MARK: - Life Cycle

    init(mediaType: MediaType,
         mediaID: Int,
         router: NavigationRouter,
         diContainer: Container) {
        self.itemType = mediaType
        self.itemID = mediaID
        self.router = router
        self.moduleSupplier = diContainer.resolve(ModuleFactoryProtocol.self)!
        self.coordinatorSupplier = diContainer.resolve(FlowCoordinatorProvider.self)!

        super.init()
    }

    // MARK: - API

    override func start() {
        showDetailModule()
    }

    // MARK: - Private Methods

    private func showDetailModule() {
        let (route, module) = moduleSupplier.makeDetailModule(itemType: itemType, itemID: itemID)

        route.showDetail = { [unowned self] type, id in
            self.runDetailCoordinator(itemType: type, itemID: id)
        }

        route.closeModule = { [unowned self] in
            self.finishFlow?()
        }


        let loadModule = self.moduleSupplier.makeLoadModule()
        self.router.present(loadModule)

        route.loading = { [unowned self] isLoading in
            guard isLoading else {
                self.router.dismissModule()
                return
            }
        }

        router.push(module)
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
