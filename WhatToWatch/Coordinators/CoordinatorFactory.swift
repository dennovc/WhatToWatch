//
//  CoordinatorFactory.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    func makeTabBarCoordinator() -> (configurator: FlowCoordinator, toPresent: Presentable) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(route: controller, coordinatorSupplier: CoordinatorFactory())

        return (coordinator, controller)
    }

    func makeSearchCoordinator(router: NavigationRouter) -> FlowCoordinator {
        return SearchCoordinator(router: router,
                                 moduleSupplier: ModuleFactory(),
                                 coordinatorSupplier: CoordinatorFactory())
    }

    func makeDetailCoordinator(itemType: ScopeButton,
                               itemID: Int,
                               router: NavigationRouter) -> FlowCoordinator & DetailCoordinatorOutput {
        return DetailCoordinator(itemType: itemType,
                                 itemID: itemID,
                                 router: router,
                                 moduleSupplier: ModuleFactory(),
                                 coordinatorSupplier: CoordinatorFactory())
    }

    func makeDiscoverCoordinator(router: NavigationRouter) -> FlowCoordinator {
        return DiscoverCoordinator(router: router,
                                 moduleSupplier: ModuleFactory(),
                                 coordinatorSupplier: CoordinatorFactory())
    }

}
