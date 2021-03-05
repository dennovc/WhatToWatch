//
//  MockRouter.swift
//  WhatToWatchTests
//
//  Created by Denis Novitsky on 05.03.2021.
//

@testable import WhatToWatch

final class MockRouter: RouterProtocol {

    // MARK: - Properties

    private(set) var navigationStack = [Presentable]()
    private(set) var presentedModule: Presentable?
    private(set) var navigationBarIsHidden = false

    // MARK: - Methods

    func present(_ module: Presentable) {
        presentedModule = module
    }

    func dismissModule() {
        presentedModule = nil
    }

    func push(_ module: Presentable) {
        navigationStack.append(module)
    }

    func popModule() {
        navigationStack.removeLast()
    }

    func setRootModule(_ module: Presentable, hideNavigationBar: Bool) {
        navigationStack = [module]
        navigationBarIsHidden = hideNavigationBar
    }
    
}
