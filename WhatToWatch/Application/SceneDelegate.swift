//
//  SceneDelegate.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Private Properties

    lazy var appCoordinator: CoordinatorProtocol = {
        let rootController = window!.rootViewController as! UINavigationController
        let router = Router(rootController: rootController)
        let supplierOfCoordinators = CoordinatorFactory()

        return AppCoordinator(router: router, supplierOfCoordinators: supplierOfCoordinators)
    }()

    // MARK: - Scene Life Cycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        configureRootController(with: windowScene)
        appCoordinator.start()
    }

    // MARK: - Private Methods

    private func configureRootController(with scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
    }

}
