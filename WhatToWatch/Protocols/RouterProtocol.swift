//
//  RouterProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

protocol RouterProtocol: class {

    func present(_ module: Presentable)

    func dismissModule()

    func push(_ module: Presentable)

    func popModule()

    func setRootModule(_ module: Presentable)
    func setRootModule(_ module: Presentable, hideNavigationBar: Bool)

}

// MARK: - Default Implementations

extension RouterProtocol {

    func setRootModule(_ module: Presentable) {
        setRootModule(module, hideNavigationBar: false)
    }

}
