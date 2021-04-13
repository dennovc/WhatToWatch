//
//  Router.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit

final class Router: RouterProtocol {

    // MARK: - Private Properties

    private weak var rootController: UINavigationController?

    // MARK: - Life Cycle

    init(rootController: UINavigationController) {
        self.rootController = rootController
    }

    // MARK: - Methods

    func present(_ module: Presentable) {
        guard let controller = module.toPresent() else { return }
        rootController?.present(controller, animated: false)
    }

    func dismissModule() {
        rootController?.dismiss(animated: false)
    }

    func push(_ module: Presentable) {
        guard let controller = module.toPresent() else { return }
        rootController?.pushViewController(controller, animated: true)
    }

    func popModule() {
        rootController?.popViewController(animated: true)
    }

    func setRootModule(_ module: Presentable, hideNavigationBar: Bool) {
        guard let controller = module.toPresent() else { return }

        rootController?.setViewControllers([controller], animated: false)
        rootController?.setNavigationBarHidden(hideNavigationBar, animated: false)
    }

}
