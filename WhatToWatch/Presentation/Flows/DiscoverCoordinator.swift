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
    private let coordinatorProvider: FlowCoordinatorProvider
    private let moduleProvider: ModuleProvider

    init(router: NavigationRouter, diContainer: Container) {
        self.router = router
        self.coordinatorProvider = diContainer.resolve(FlowCoordinatorProvider.self)!
        self.moduleProvider = diContainer.resolve(ModuleProvider.self)!

        super.init()
    }

    // MARK: - Methods

    override func start() {
        showDiscoverModule()
    }

    // MARK: - Private Methods

    private func showDiscoverModule() {
        let (route, module) = moduleProvider.makeDiscoverModule()

        route.onDetail = { [weak self] media in
            self?.runDetailCoordinator(media: media)
        }

        route.onLoading = { [weak self] isLoading in
            guard let self = self else { return }

            if isLoading {
                let module = self.moduleProvider.makeLoadingModule()
                self.router.present(module, animated: false)
            } else {
                self.router.dismissModule(animated: false)
            }
        }

        route.onError = { [weak self] message in
            guard let self = self else { return }

            let module = self.moduleProvider.makeMessageAlertModule(title: "Error", message: message)
            self.router.present(module)
        }

        router.setRootModule(module)
    }

    private func runDetailCoordinator(media: Media) {
        let coordinator = coordinatorProvider.makeDetailCoordinator(media: media, router: router)

        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }

        addDependency(coordinator)
        coordinator.start()
    }

}
