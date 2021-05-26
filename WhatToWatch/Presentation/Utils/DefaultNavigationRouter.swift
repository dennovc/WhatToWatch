//
//  DefaultNavigationRouter.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit

final class DefaultNavigationRouter {

    private weak var rootController: UINavigationController?

    init(rootController: UINavigationController) {
        self.rootController = rootController
    }

}

// MARK: - Navigation Router

extension DefaultNavigationRouter: NavigationRouter {

    func present(_ module: Presentable, animated: Bool) {
        guard let controller = module.toPresent() else { return }
        rootController?.present(controller, animated: animated)
    }

    func dismissModule(animated: Bool) {
        rootController?.dismiss(animated: animated)
    }

    func push(_ module: Presentable, animated: Bool) {
        guard let controller = module.toPresent() else { return }
        rootController?.pushViewController(controller, animated: animated)
    }

    func popModule(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }

    func setRootModule(_ module: Presentable, hideNavigationBar: Bool) {
        guard let controller = module.toPresent() else { return }

        rootController?.setViewControllers([controller], animated: false)
        rootController?.setNavigationBarHidden(hideNavigationBar, animated: false)
    }

}
