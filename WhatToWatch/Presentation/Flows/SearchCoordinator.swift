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
        showSearchModule()
    }

    // MARK: - Private Methods

    private func showSearchModule() {
        let (route, module) = moduleProvider.makeSearchModule()

        route.showDetail = { [weak self] mediaType, mediaID in
            self?.runDetailCoordinator(mediaType: mediaType, mediaID: mediaID)
        }

        router.setRootModule(module)
    }

    private func runDetailCoordinator(mediaType: MediaType, mediaID: Int) {
//        let coordinator = coordinatorProvider.makeDetailCoordinator(mediaType: mediaType,
//                                                                    mediaID: mediaID,
//                                                                    router: router)
//
//        coordinator.finishFlow = { [unowned self, unowned coordinator] in
//            self.removeDependency(coordinator)
//        }
//
//        addDependency(coordinator)
//        coordinator.start()
    }

}
