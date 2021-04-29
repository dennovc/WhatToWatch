//
//  CoordinatorFactoryProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

protocol CoordinatorFactoryProtocol: class {

    func makeTabBarCoordinator() -> (configurator: FlowCoordinator, toPresent: Presentable)
    
    func makeSearchCoordinator(router: NavigationRouter) -> FlowCoordinator

    func makeDetailCoordinator(itemType: ScopeButton,
                               itemID: Int,
                               router: NavigationRouter) -> FlowCoordinator & DetailCoordinatorOutput

    func makeDiscoverCoordinator(router: NavigationRouter) -> FlowCoordinator

}
