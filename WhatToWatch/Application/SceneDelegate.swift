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

    private lazy var appCoordinator: FlowCoordinator = {
        let controller = window!.rootViewController as! UINavigationController
        let router = DefaultNavigationRouter(rootController: controller)

        return AppCoordinator(router: router, coordinatorSupplier: CoordinatorFactory())
    }()

    // MARK: - Scene Life Cycle

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        configureWindow(with: windowScene)
        appCoordinator.start()
    }

    // MARK: - Private Methods

    private func configureWindow(with scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = UINavigationController()
        window?.makeKeyAndVisible()
    }

}
