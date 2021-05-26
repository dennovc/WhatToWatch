//
//  DetailCoordinator.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 07.04.2021.
//

import Foundation
import Swinject

protocol DetailCoordinatorOutput: AnyObject {

    var finishFlow: (() -> Void)? { get set }

}

final class DetailCoordinator: BaseFlowCoordinator, DetailCoordinatorOutput {

    // MARK: - Output

    var finishFlow: (() -> Void)?

    // MARK: - Private Properties

    private let media: Media

    private let router: NavigationRouter
    private let coordinatorProvider: FlowCoordinatorProvider
    private let moduleProvider: ModuleProvider

    init(media: Media,
         router: NavigationRouter,
         diContainer: Container) {
        self.media = media

        self.router = router
        self.coordinatorProvider = diContainer.resolve(FlowCoordinatorProvider.self)!
        self.moduleProvider = diContainer.resolve(ModuleProvider.self)!

        super.init()
    }

    // MARK: - Methods

    override func start() {
        showDetailModule()
    }

    // MARK: - Private Methods

    private func showDetailModule() {
        let (route, module) = moduleProvider.makeDetailModule(media: media)

        route.onDetail = { [weak self] media in
            self?.runDetailCoordinator(media: media)
        }

        route.onDismiss = { [weak self] in
            self?.finishFlow?()
        }

        route.onLoading = { [weak self] isLoading in
            guard let self = self else { return }

            if isLoading {
                let module = self.moduleProvider.makeLoadingModule()
                self.router.present(module, animated: false)
            } else {
                self.router.dismissModule(animated: false)
            }
        }

        route.onError = { [weak self] message in
            guard let self = self else { return }

            let module = self.moduleProvider.makeMessageAlertModule(title: "Error", message: message)
            self.router.present(module)
        }

        router.push(module)
    }

    private func runDetailCoordinator(media: Media) {
        let coordinator = coordinatorProvider.makeDetailCoordinator(media: media, router: router)

        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
        }

        addDependency(coordinator)
        coordinator.start()
    }

}
