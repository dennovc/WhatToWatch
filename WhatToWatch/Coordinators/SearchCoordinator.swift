//
//  SearchCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class SearchCoordinator: BaseCoordinator {

    // MARK: - Private Properties

    private let router: RouterProtocol
    private let moduleSupplier: ModuleFactoryProtocol
    private let coordinatorSupplier: CoordinatorFactoryProtocol

    // MARK: - Life Cycle

    init(router: RouterProtocol,
         moduleSupplier: ModuleFactoryProtocol,
         coordinatorSupplier: CoordinatorFactoryProtocol) {
        self.router = router
        self.moduleSupplier = moduleSupplier
        self.coordinatorSupplier = coordinatorSupplier

        super.init()
    }

    // MARK: - Methods

    override func start() {}

}
