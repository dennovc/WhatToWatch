//
//  CoordinatorFactory.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(route: controller, coordinatorSupplier: CoordinatorFactory())

        return (coordinator, controller)
    }

    func makeSearchCoordinator(router: RouterProtocol) -> CoordinatorProtocol {
        return SearchCoordinator(router: router,
                                 moduleSupplier: ModuleFactory(),
                                 coordinatorSupplier: CoordinatorFactory())
    }

}
