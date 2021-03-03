//
//  SearchCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

final class SearchCoordinator: CoordinatorProtocol {

    // MARK: - Private Properties

    private let router: RouterProtocol

    // MARK: - Life Cycle

    init(router: RouterProtocol) {
        self.router = router
    }

    // MARK: - Methods

    func start() {}

}
