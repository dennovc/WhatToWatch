//
//  DefaultModuleProvider.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.03.2021.
//

import Foundation
import Swinject

final class DefaultModuleProvider {

    private weak var diContainer: Container!

    init(diContainer: Container) {
        self.diContainer = diContainer
    }

}

// MARK: - Module Provider

extension DefaultModuleProvider: ModuleProvider {

    func makeDiscoverModule() -> (configurator: DiscoverRoute, toPresent: Presentable) {
        let trendsUseCase = diContainer.resolve(MediaTrendsUseCase.self)!
        let imageRepository = diContainer.resolve(ImageRepository.self)!

        let viewModel = DiscoverViewModel(trendsUseCase: trendsUseCase)
        let view = DiscoverController(viewModel: viewModel, imageRepository: imageRepository)

        return (viewModel, view)
    }

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable) {
        let viewModel = SearchViewModel(movieAPIService: TMDBService.shared)
        let view = SearchController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeDetailModule(media: Media) -> (configurator: DetailRoute, toPresent: Presentable) {
        let detailUseCase = diContainer.resolve(MediaDetailUseCase.self)!
        let imageRepository = diContainer.resolve(ImageRepository.self)!

        let viewModel = DetailViewModel(media: media, detailUseCase: detailUseCase)
        let view = DetailController(viewModel: viewModel, imageRepository: imageRepository)

        return (viewModel, view)
    }

    func makeLoadingModule() -> Presentable {
        return LoadingController()
    }

    func makeMessageAlertModule(title: String?, message: String?) -> Presentable {
        return MessageAlertController(title: title, message: message)
    }

}
