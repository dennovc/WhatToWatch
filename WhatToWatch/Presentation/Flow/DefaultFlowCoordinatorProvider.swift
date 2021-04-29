//
//  DefaultFlowCoordinatorProvider.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation
import Swinject

final class DefaultFlowCoordinatorProvider {

    private weak var diContainer: Container!

    init(diContainer: Container) {
        self.diContainer = diContainer
    }

}

// MARK: - Flow Coordinator Provider

extension DefaultFlowCoordinatorProvider: FlowCoordinatorProvider {

    func makeTabBarCoordinator() -> (configurator: FlowCoordinator, toPresent: Presentable) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(route: controller, diContainer: diContainer)

        return (coordinator, controller)
    }

    func makeDiscoverCoordinator(router: NavigationRouter) -> FlowCoordinator {
        return DiscoverCoordinator(router: router, diContainer: diContainer)
    }

    func makeSearchCoordinator(router: NavigationRouter) -> FlowCoordinator {
        return SearchCoordinator(router: router, diContainer: diContainer)
    }

    func makeDetailCoordinator(mediaType: MediaType,
                               mediaID: Int,
                               router: NavigationRouter) -> FlowCoordinator & DetailCoordinatorOutput {
        return DetailCoordinator(mediaType: mediaType,
                                 mediaID: mediaID,
                                 router: router,
                                 diContainer: diContainer)
    }

}
