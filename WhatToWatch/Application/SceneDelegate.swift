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

        container.register(AppConfiguration.self) { _ in
            return AppConfiguration()
        }.inObjectScope(.container)

        // Providers

        container.register(FlowCoordinatorProvider.self) { [unowned container] _ in
            return DefaultFlowCoordinatorProvider(diContainer: container)
        }

        container.register(ModuleProvider.self) { [unowned container] _ in
            return DefaultModuleProvider(diContainer: container)
        }

        // Services

        container.register(NetworkService.self) { _, config in
            return DefaultNetworkService(config: config)
        }

        container.register(DataTransferService.self) { (resolver, config: NetworkConfigurable) in
            let networkService = resolver.resolve(NetworkService.self, argument: config)!
            return DefaultDataTransferService(networkService: networkService)
        }

        // Repositories

        container.register(MediaRepository.self) { resolver in
            let appConfiguration = resolver.resolve(AppConfiguration.self)!
            let config: NetworkConfigurable = NetworkConfig(baseURL: appConfiguration.apiBaseURL,
                                                            queryParameters: ["api_key": appConfiguration.apiKey])

            let dataTransferService = resolver.resolve(DataTransferService.self, argument: config)!
            let cacheService = DefaultCacheService<MediaRepositoryCacheKey, Media>()

            return DefaultMediaRepository(dataTransferService: dataTransferService, cacheService: cacheService)
        }.inObjectScope(.container)

        container.register(ImageRepository.self) { resolver in
            let appConfiguration = resolver.resolve(AppConfiguration.self)!
            let config: NetworkConfigurable = NetworkConfig(baseURL: appConfiguration.imageBaseURL,
                                                            queryParameters: [:])

            let dataTransferService = resolver.resolve(DataTransferService.self, argument: config)!
            let cacheService = DefaultCacheService<String, Data>()

            return DefaultImageRepository(dataTransferService: dataTransferService, cacheService: cacheService)
        }.inObjectScope(.container)

        // Use Cases

        container.register(MediaTrendsUseCase.self) { resolver in
            let mediaRepository = resolver.resolve(MediaRepository.self)!
            return DefaultMediaTrendsUseCase(mediaRepository: mediaRepository)
        }

        container.register(SearchMediaUseCase.self) { resolver in
            let mediaRepository = resolver.resolve(MediaRepository.self)!
            return DefaultSearchMediaUseCase(mediaRepository: mediaRepository)
        }

        container.register(MediaDetailUseCase.self) { resolver in
            let mediaRepository = resolver.resolve(MediaRepository.self)!
            return DefaultMediaDetailUseCase(mediaRepository: mediaRepository)
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
