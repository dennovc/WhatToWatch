//
//  CoordinatorFactory.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(tabBarRoute: controller, supplierOfCoordinators: CoordinatorFactory())

        return (coordinator, controller)
    }

    func makeSearchCoordinator(rootController: UINavigationController) -> CoordinatorProtocol {
        let router = Router(rootController: rootController)
        let coordinator = SearchCoordinator(router: router)

        return coordinator
    }

}
