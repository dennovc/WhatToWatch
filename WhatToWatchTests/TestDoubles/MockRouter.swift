//
//  MockRouter.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

@testable import WhatToWatch

final class MockRouter: RouterProtocol {

    // MARK: - Methods

    func present(_ module: Presentable) {}

    func dismissModule() {}

    func push(_ module: Presentable) {}

    func popModule() {}

    func setRootModule(_ module: Presentable, hideNavigationBar: Bool) {}
    
}
