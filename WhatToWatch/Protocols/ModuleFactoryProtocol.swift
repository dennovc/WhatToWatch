//
//  ModuleFactoryProtocol.swift
//  WhatToWatch
//
//  Created by Denis Novitsky on 05.03.2021.
//

protocol ModuleFactoryProtocol: class {

    func makeSearchModule() -> (configurator: SearchRoute, toPresent: Presentable)

    func makeDetailModule(itemType: ScopeButton, itemID: Int) -> (configurator: DetailRoute, toPresent: Presentable)

    func makeDiscoverModule() -> (configurator: DiscoverRoute, toPresent: Presentable)

    func makeLoadModule() -> Presentable

    func makeMessageAlertModule(title: String?, message: String?) -> Presentable

}
