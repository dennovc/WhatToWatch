//
//  FlowCoordinatorProvider.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import Foundation

protocol FlowCoordinatorProvider {

    func makeTabBarCoordinator() -> (configurator: FlowCoordinator, toPresent: Presentable)

    func makeDiscoverCoordinator(router: NavigationRouter) -> FlowCoordinator

    func makeSearchCoordinator(router: NavigationRouter) -> FlowCoordinator

    func makeDetailCoordinator(media: Media,
                               router: NavigationRouter) -> FlowCoordinator & DetailCoordinatorOutput

}
