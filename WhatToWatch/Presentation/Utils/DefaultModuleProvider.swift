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
        let viewModel = DiscoverViewModel(movieAPIService: TMDBService.shared)
        let view = DiscoverViewController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable) {
        let viewModel = SearchViewModel(movieAPIService: TMDBService.shared)
        let view = SearchController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeDetailModule(mediaType: MediaType, mediaID: Int) -> (configurator: DetailRoute, toPresent: Presentable) {
        let viewModel = DetailViewModel(itemType: mediaType, itemID: mediaID, movieAPIService: TMDBService.shared)
        let view = DetailController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeLoadingModule() -> Presentable {
        return LoadingController()
    }

    func makeMessageAlertModule(title: String?, message: String?) -> Presentable {
        return MessageAlertController(title: title, message: message)
    }

}
