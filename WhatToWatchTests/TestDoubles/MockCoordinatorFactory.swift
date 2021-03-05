//
//  MockCoordinatorFactory.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

@testable import WhatToWatch

final class MockCoordinatorFactory: CoordinatorFactoryProtocol {

    // MARK: - Properties

    private(set) weak var coordinator: MockCoordinator?
    private(set) var module: Presentable = MockNavigationController()

    // MARK: - Methods

    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable) {
        return (makeCoordinator(), module)
    }

    func makeSearchCoordinator(router: RouterProtocol) -> CoordinatorProtocol {
        return makeCoordinator()
    }

    // MARK: - Private Methods

    private func makeCoordinator() -> MockCoordinator {
        let mockCoordinator = MockCoordinator()
        coordinator = mockCoordinator

        return mockCoordinator
    }

}
