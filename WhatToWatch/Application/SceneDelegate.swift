//
//  SceneDelegate.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 27.02.2021.
//

import UIKit
import Swinject

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Private Properties

    private let diContainer: Container = {
        let container = Container()

        container.register(FlowCoordinatorProvider.self) { [unowned container] _ in
            return DefaultFlowCoordinatorProvider(diContainer: container)
        }

        container.register(ModuleProvider.self) { [unowned container] _ in
            return DefaultModuleProvider(diContainer: container)
        }

        return container
    }()

    private lazy var appCoordinator: FlowCoordinator = {
        let controller = window!.rootViewController as! UINavigationController
        let router = DefaultNavigationRouter(rootController: controller)

        return AppCoordinator(router: router, diContainer: diContainer)
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
