//
//  CoordinatorFactoryProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

protocol CoordinatorFactoryProtocol {

    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable)
    func makeSearchCoordinator(router: RouterProtocol) -> CoordinatorProtocol

}
