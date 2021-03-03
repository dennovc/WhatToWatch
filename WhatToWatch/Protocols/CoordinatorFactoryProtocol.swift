//
//  CoordinatorFactoryProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 03.03.2021.
//

import UIKit

protocol CoordinatorFactoryProtocol {

    func makeTabBarCoordinator() -> (configurator: CoordinatorProtocol, toPresent: Presentable)
    func makeSearchCoordinator(rootController: UINavigationController) -> CoordinatorProtocol

}
