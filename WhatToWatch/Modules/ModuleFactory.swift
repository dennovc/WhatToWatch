//
//  ModuleFactory.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.03.2021.
//

final class ModuleFactory: ModuleFactoryProtocol {

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable) {
        let viewModel = SearchViewModel(movieAPIService: TMDBService.shared)
        let view = SearchController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeDetailModule(itemType: ScopeButton, itemID: Int) -> (configurator: DetailRoute, toPresent: Presentable) {
        let viewModel = DetailViewModel(itemType: itemType, itemID: itemID, movieAPIService: TMDBService.shared)
        let view = DetailController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeDiscoverModule() -> (configurator: DiscoverRoute, toPresent: Presentable) {
        let viewModel = DiscoverViewModel(movieAPIService: TMDBService.shared)
        let view = DiscoverViewController(viewModel: viewModel)

        return (viewModel, view)
    }

    func makeLoadModule() -> Presentable {
        let view = LoadController()
        return view
    }

    func makeMessageAlertModule(title: String?, message: String?) -> Presentable {
        let view = MessageAlertController(title: title, message: message)
        return view
    }

}
