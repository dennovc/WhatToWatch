//
//  MockCoordinatorFactory.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

@testable import WhatToWatch

//final class MockCoordinatorFactory: CoordinatorFactoryProtocol {
//
//    // MARK: - Properties
//
//    let returnedModule = MockModule()
//    private(set) weak var returnedCoordinator: MockCoordinator?
//    private(set) var receivedRouter: RouterProtocol?
//
//    // MARK: - Methods
//
//    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable) {
//        return (makeCoordinator(), returnedModule)
//    }
//
//    func makeSearchCoordinator(router: RouterProtocol) -> CoordinatorProtocol {
//        receivedRouter = router
//        return makeCoordinator()
//    }
//
//    // MARK: - Private Methods
//
//    private func makeCoordinator() -> CoordinatorProtocol {
//        let coordinator = MockCoordinator()
//        returnedCoordinator = coordinator
//
//        return coordinator
//    }
//
//}
