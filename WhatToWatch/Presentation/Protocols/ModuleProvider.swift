//
//  ModuleProvider.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.03.2021.
//

import Foundation

protocol ModuleProvider {

    func makeDiscoverModule() -> (configurator: DiscoverRoute, toPresent: Presentable)

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable)

    func makeDetailModule(media: Media) -> (configurator: DetailRoute, toPresent: Presentable)

    func makeLoadingModule() -> Presentable

    func makeMessageAlertModule(title: String?, message: String?) -> Presentable

}
