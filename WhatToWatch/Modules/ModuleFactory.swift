//
//  ModuleFactory.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.03.2021.
//

final class ModuleFactory: ModuleFactoryProtocol {

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable) {
        let networkService = NetworkService()
        let movieAPIService = TMDBService(networkService: networkService)
        let viewModel = SearchViewModel(movieAPIService: movieAPIService)
        let view = SearchController(viewModel: viewModel)

        return (viewModel, view)
    }

}
